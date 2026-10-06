#!/usr/bin/env python3
"""Prepare the generated English app and catalog for Xcode's English scheme."""

from pathlib import Path
import shutil
import tempfile

from build_tutorial_site import ENGLISH, prepare_app, prepare_english


def main():
    destination = ENGLISH / "Generated"
    # Prepare and validate first, so a translation error can't remove usable outputs.
    with tempfile.TemporaryDirectory(prefix="techmap-xcode-english-") as temp:
        app = Path(temp) / "ARDominoChainReaction"
        prepare_app(app, "en")
        prepare_english(app / "ARDominoChainReaction.docc")
        (app / "project.yml").unlink()
        if destination.exists():
            if not (destination / ".generated-by-techmap").is_file():
                raise ValueError(f"Refusing to replace an unmarked directory: {destination}")
            shutil.rmtree(destination)
        shutil.copytree(app, destination)
        (destination / ".generated-by-techmap").touch()
    print("Prepared English app and DocC catalog for ARDominoChainReaction-English.")


if __name__ == "__main__":
    main()
