#!/usr/bin/env python3
"""Build Korean, English, and legacy DocC routes from shared resources."""

import argparse
import html
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import xml.etree.ElementTree as ET


PROJECT = Path(__file__).resolve().parents[2]
SITE = PROJECT / "Docs/Site"
KOREAN = PROJECT / "ARDominoChainReaction.docc"
ENGLISH = PROJECT / "English"
HANGUL = re.compile(r"[가-힣]")
SVG_NS = "http://www.w3.org/2000/svg"


def translations():
    return json.loads((ENGLISH / "translations.json").read_text())


def require_english(text, path):
    if HANGUL.search(text):
        lines = [line.strip() for line in text.splitlines() if HANGUL.search(line)]
        raise ValueError(f"Untranslated text in {path}: {lines}")


def translate_swift(text, mapping):
    """Translate whole comment lines and string content without changing logic."""
    result = []
    for line in text.splitlines(keepends=True):
        if HANGUL.search(line):
            if line.lstrip().startswith("//"):
                original = line.lstrip()[2:].strip()
                line = line.replace(original, mapping[original])
            else:
                # Longer matches first; only string-bearing lines reach this branch.
                for original, translated in sorted(mapping.items(), key=lambda item: -len(item[0])):
                    if HANGUL.search(original) and original in line:
                        line = line.replace(original, translated)
        result.append(line)
    return "".join(result)


def translate_svg(text, mapping):
    """Preserve vector geometry and translate individual XML text nodes."""
    ET.register_namespace("", SVG_NS)
    root = ET.fromstring(text)
    for element in root.iter():
        if element.text and HANGUL.search(element.text):
            original = element.text.strip()
            element.text = element.text.replace(original, mapping[original])
    return ET.tostring(root, encoding="unicode")


def prepare_english(destination):
    shutil.copytree(ENGLISH / "ARDominoChainReaction.docc", destination)
    resources = destination / "Resources"
    shutil.copytree(KOREAN / "Resources", resources)
    mapping = translations()
    for path in resources.iterdir():
        if path.suffix == ".swift":
            text = translate_swift(path.read_text(), mapping)
            require_english(text, path)
            path.write_text(text)
        elif path.suffix == ".svg":
            text = translate_svg(path.read_text(), mapping)
            require_english(text, path)
            path.write_text(text)
    for path in (ENGLISH / "Resources").iterdir():
        shutil.copy2(path, resources / path.name)
    for path in destination.rglob("*.tutorial"):
        require_english(path.read_text(), path)
    validate_catalogs(KOREAN, destination)


def resource_refs(text):
    return re.findall(r'\b(?:source|file|previousFile)\s*:\s*"?([^\s,"\)]+)', text)


def validate_catalogs(korean, english):
    originals = {path.relative_to(korean) for path in korean.rglob("*.tutorial")}
    translated = {path.relative_to(english) for path in english.rglob("*.tutorial")}
    if originals != translated:
        raise ValueError("Korean and English tutorial filenames differ")
    for relative in originals:
        ko = (korean / relative).read_text()
        en = (english / relative).read_text()
        # Compare directives and code/resource links, including previousFile.
        if re.findall(r"@(\w+)\(", ko) != re.findall(r"@(\w+)\(", en):
            raise ValueError(f"Directive structure differs in {relative}")
        if ko.count("@Step {") != en.count("@Step {"):
            raise ValueError(f"Step count differs in {relative}")
        if resource_refs(ko) != resource_refs(en):
            raise ValueError(f"Resource references differ in {relative}")
        for name in resource_refs(en):
            if not (english / "Resources" / name).is_file():
                raise ValueError(f"Missing resource: {name}")


def prepare_app(destination, language):
    shutil.copytree(PROJECT / "Sources", destination / "Sources")
    # Downloaded projects contain only the app, without local documentation targets.
    config = (PROJECT / "app-project.yml").read_text()
    config = "\n".join(line for line in config.splitlines() if "path: ARDominoChainReaction.docc" not in line) + "\n"
    if language == "en":
        mapping = translations()
        for path in (destination / "Sources").rglob("*.swift"):
            text = translate_swift(path.read_text(), mapping)
            require_english(text, path)
            path.write_text(text)
        # Plist's purpose string and XcodeGen's generated value must agree.
        purpose = "AR 도미노 체인리액션에서 ARKit 카메라 트래킹을 사용하기 위해 카메라 접근 권한이 필요합니다."
        config = config.replace(purpose, mapping[purpose])
        for path in (destination / "Sources").rglob("*.plist"):
            text = path.read_text().replace(purpose, mapping[purpose])
            require_english(text, path)
            path.write_text(text)
    (destination / "project.yml").write_text(config)


def build_catalog(catalog, output, base, language):
    subprocess.run([
        "xcrun", "docc", "convert", str(catalog),
        "--fallback-display-name", "ARDominoChainReaction",
        "--fallback-bundle-identifier", "com.techmap.ardominochainreaction.ARDominoChainReaction",
        "--output-path", str(output),
        "--hosting-base-path", base,
        "--transform-for-static-hosting",
        "--warnings-as-errors",
    ], check=True)
    script_path = "/" + base.strip("/") + "/language-switch.js"
    canonical_base = "/" + base.strip("/")
    for path in output.rglob("*.html"):
        text = path.read_text()
        text = re.sub(r'<html\b[^>]*>', f'<html lang="{language}">', text, count=1)
        text = text.replace("</head>", f'<script defer src="{html.escape(script_path)}"></script></head>')
        route = "/" + path.parent.relative_to(output).as_posix()
        if route == "/.":
            route = "/tutorials/ardominochainreactiontutorials"
        alternate_base = re.sub(r"/(ko|en)$", "", canonical_base)
        for lang in ("ko", "en"):
            text = text.replace("</head>", f'<link rel="alternate" hreflang="{lang}" href="{alternate_base}/{lang}{route}/"></head>')
        path.write_text(text)
    shutil.copy2(SITE / "language-switch.js", output / "language-switch.js")
    # Recent DocC renderers request this optional file even with the default theme.
    (output / "theme-settings.json").write_text("{}\n")


def language_routes(output):
    routes = {}
    data = output / "en/data"
    for path in data.rglob("*.json"):
        relative = path.relative_to(data)
        korean_path = output / "ko/data" / relative
        if not korean_path.exists():
            continue
        en = json.loads(path.read_text())
        ko = json.loads(korean_path.read_text())
        en_tasks = [task for section in en.get("sections", []) for task in section.get("tasks", [])]
        ko_tasks = [task for section in ko.get("sections", []) for task in section.get("tasks", [])]
        if en_tasks:
            if len(en_tasks) != len(ko_tasks):
                raise ValueError(f"Rendered task count differs in {relative}")
            routes["/" + relative.with_suffix("").as_posix()] = [
                {"ko": k["anchor"], "en": e["anchor"]} for k, e in zip(ko_tasks, en_tasks)
            ]
    (output / "language-routes.json").write_text(json.dumps(routes, ensure_ascii=False))


def redirect(path, destination, language):
    path.write_text(f'<!doctype html><html lang="{language}"><meta charset="utf-8"><meta http-equiv="refresh" content="0;url={destination}"><title>AR Domino Chain Reaction</title><a href="{destination}">Continue to the tutorial</a></html>')


def build(output, base, package_apps):
    if output.exists():
        raise ValueError(f"Output already exists; choose a new directory: {output}")
    with tempfile.TemporaryDirectory(prefix="techmap-bilingual-") as temp:
        work = Path(temp)
        en_catalog = work / "ARDominoChainReaction.docc"
        prepare_english(en_catalog)
        # Preserve existing /tutorials/... links as Korean pages.
        build_catalog(KOREAN, output, base, "ko")
        build_catalog(KOREAN, output / "ko", base + "/ko", "ko")
        build_catalog(en_catalog, output / "en", base + "/en", "en")
        language_routes(output)
        redirect(output / "index.html", "ko/tutorials/ardominochainreactiontutorials/", "ko")
        (output / ".nojekyll").touch()
        for lang in ("ko", "en"):
            redirect(output / lang / "index.html", "tutorials/ardominochainreactiontutorials/", lang)
        if package_apps:
            for lang in ("ko", "en"):
                package_root = work / lang
                app = package_root / "ARDominoChainReaction"
                prepare_app(app, lang)
                subprocess.run(["xcodegen", "generate"], cwd=app, check=True)
                suffix = "-EN" if lang == "en" else ""
                subprocess.run(["zip", "-rqX", str(output / f"ARDominoChainReaction-Final{suffix}.zip"), "ARDominoChainReaction", "-x", "*.DS_Store"], cwd=package_root, check=True)
    print(f"Bilingual tutorial built at {output}")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--base-path", default="2026TechMap_tutorial")
    parser.add_argument("--package-apps", action="store_true")
    parser.add_argument("--prepare-only", action="store_true", help="Prepare the English catalog for local Xcode or DocC use")
    args = parser.parse_args()
    if args.prepare_only:
        prepare_english(args.output.resolve())
    else:
        build(args.output.resolve(), args.base_path.strip("/"), args.package_apps)


if __name__ == "__main__":
    main()
