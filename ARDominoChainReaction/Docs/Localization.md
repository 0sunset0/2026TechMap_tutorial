# 한국어·영어 튜토리얼

한국어 확정본은 `ARDominoChainReaction.docc/`에 그대로 유지합니다. 영어 본문은 `English/ARDominoChainReaction.docc/`에서 관리합니다. 장과 스텝의 순서, 코드의 실행 로직과 파일 참조는 두 버전이 같습니다.

## 독자 진입과 언어 전환

- `/2026TechMap_tutorial/`: 한국어 목차로 바로 이동.
- `/2026TechMap_tutorial/ko/`: 한국어 목차로 이동.
- `/2026TechMap_tutorial/en/`: 영어 목차로 이동.
- 각 목차와 장 상단의 `한국어 / English` 링크: 현재 장의 다른 언어판으로 이동. 번역으로 달라진 절 제목의 앵커도 대응시켜 같은 절로 이동합니다.
- 기존 `/2026TechMap_tutorial/tutorials/...`: 한국어 페이지로 계속 제공.

한국어와 영어 모두 기존 파일 이름을 유지해 언어를 바꿔도 장의 경로가 대응하도록 합니다. 브라우저 언어로 강제 이동하지 않아 사용자가 직접 선택할 수 있습니다.

## 공통 리소스와 번역

`Docs/Tools/build_tutorial_site.py`가 임시 영어 카탈로그를 준비합니다.

1. 한국어 카탈로그의 공통 코드·이미지·애니메이션을 복사합니다.
2. `English/translations.json`으로 Swift 주석과 상태 문자열, SVG 텍스트를 번역합니다. 코드의 실행 로직과 SVG 도형은 유지합니다.
3. `English/Resources/`의 영어 PNG 5개로 한국어 텍스트가 있는 이미지를 대체합니다.
4. 장·스텝·리소스 참조가 두 언어에서 동일한지 확인하고, 영어 텍스트 파일에 남은 한글이 있으면 빌드를 중단합니다.
5. DocC로 기존 한국어 주소, `/ko`, `/en`을 빌드하고 상단 언어 링크를 붙입니다.

빌드 결과를 소스 카탈로그에 되돌려 복사하지 않습니다. 공통 코드 수정은 한국어 원본에 한 번 적용하고, 새 주석·문자열은 번역표에 추가합니다. 한국어 본문에 변경이 생기면 영어 본문도 함께 검토해야 합니다.

실기기 사진 `domino-usdz-real-device.png`의 영어판은 실제 캡처의 배너를 AI로 번역한 이미지입니다. 영어 앱에서 새로 촬영한 사진으로 취급하지 않습니다. 이미지별 원본과 프롬프트는 [영어 이미지 기록](../English/Generated-Images.md)에 남겨둡니다.

## 로컬 빌드

저장소 루트에서 실행합니다. 출력 디렉터리는 새 경로여야 합니다.

```bash
python3 ARDominoChainReaction/Docs/Tools/build_tutorial_site.py \
  --output /tmp/techmap-site \
  --base-path 2026TechMap_tutorial \
  --package-apps
```

`--package-apps`는 XcodeGen이 필요합니다. 생략하면 문서만 빌드합니다. 다운로드 파일은 원래 한국어 앱과 영어 문자열을 사용하는 앱으로 각각 생성합니다. GitHub Actions에서는 둘 다 패키징합니다.

사이트의 base path에 맞춰 미리 보려면 `/tmp/techmap-site`를 웹 서버 루트의 `2026TechMap_tutorial` 경로에 두고 접속합니다. 예:

```bash
mkdir -p /tmp/techmap-web
ln -s /tmp/techmap-site /tmp/techmap-web/2026TechMap_tutorial
python3 -m http.server 8000 --directory /tmp/techmap-web
```

브라우저에서 `http://localhost:8000/2026TechMap_tutorial/`을 엽니다.

영어 카탈로그만 준비하려면:

```bash
python3 ARDominoChainReaction/Docs/Tools/build_tutorial_site.py \
  --prepare-only --output /tmp/ARDominoChainReaction.docc
```

## Xcode에서 언어 선택하기

`ARDominoChainReaction` 폴더에서 `xcodegen generate`를 실행하면 한국어와 영어 scheme이 함께 만들어집니다. 영어 카탈로그와 번역된 앱 소스는 `English/Generated/`에 자동으로 준비하며, 이 디렉터리는 Git에서 제외합니다. 영어 scheme을 빌드할 때도 자동 갱신합니다.

Xcode 상단의 scheme 선택 메뉴에서 다음 중 하나를 고르고 **Product ▸ Build Documentation**을 실행합니다.

- `ARDominoChainReaction`: 기존 한국어 튜토리얼과 앱.
- `ARDominoChainReaction-English`: 영어 튜토리얼과 영어 상태 문구를 사용하는 앱.

영어 scheme은 별도 타겟과 문서 아카이브를 사용하므로 한국어 원본을 덮어쓰지 않습니다. `한국어 / English` 전환 바는 웹 배포용입니다. Xcode 문서 창에서는 scheme을 선택해 각 언어 문서를 빌드합니다.

`app-project.yml`은 공통 앱 프로젝트 정의이며, 다운로드 ZIP에는 문서 타겟이 없는 앱 프로젝트만 포함됩니다. `project.yml`은 이 정의에 로컬 영어 타겟을 추가합니다.

## 배포

기존과 같이 `main` 브랜치에 푸시되거나 workflow_dispatch를 실행하면 GitHub Pages에 배포합니다. `develop`에서 작업하는 동안 공개 사이트는 변경되지 않습니다.

DocC 카탈로그를 직접 변환하고 hosting base path로 하위 경로를 구성하는 방식은 [Swift-DocC 문서](https://www.swift.org/documentation/docc/)와 [정적 호스팅 설명](https://forums.swift.org/t/support-hosting-docc-archives-in-static-hosting-environments/53572)을 참고했습니다.
