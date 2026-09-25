# AR 도미노 체인리액션 튜토리얼

![도미노가 한 줄로 연쇄적으로 쓰러지는 완성 모습](ARDominoChainReaction/ARDominoChainReaction.docc/Resources/domino-blender-demo.gif)

*완성된 앱의 연쇄 반응을 실기기 녹화를 참고해 Blender로 재현한 장면입니다.*

공간에 도미노를 여러 개 세워 배치하고, 하나를 밀면 물리 시뮬레이션으로 옆 도미노가 연쇄적으로 쓰러지는 ARKit + RealityKit 기반 AR 도미노 체인리액션 앱을 만드는 튜토리얼 저장소입니다.

**👉 [튜토리얼 바로 보기](https://0sunset0.github.io/2026TechMap_tutorial/)**

## 전체 목차

| **장** | **제목** | **핵심 개념 한 줄** |
| --- | --- | --- |
| 1 | 프로젝트 준비 | AR 앱은 왜 카메라 권한과 실기기가 필요한가 |
| 2 | 기본 AR 씬 띄우기 | ARSession과 평면 감지, UIKit↔SwiftUI 통합 |
| 3 | 도미노 한 개 만들기 | RealityKit의 Entity-Component-System |
| 4 | 탭으로 하나씩 배치하기 | Raycasting과 보이지 않는 물리 바닥 |
| 5 | 드래그로 밀어 넘어뜨리기 | 좌표계 변환과 Impulse |
| 6 | USDZ 모델로 다듬기 | 절차적 mesh에서 USDZ 에셋으로 |

## 요구 사항

- Xcode 15 이상
- iOS 17.0 이상 실기기 (A12 칩 이상, iPhone XS/XR 이후). ARKit 월드 트래킹과 People Occlusion을 모두 지원합니다
- 카메라가 없는 시뮬레이터에서는 AR 세션을 실행할 수 없어 실기기가 필요합니다
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

## 튜토리얼 보기

- **웹에서 보기**: [0sunset0.github.io/2026TechMap_tutorial](https://0sunset0.github.io/2026TechMap_tutorial/)에서 1장부터 6장까지 단계별 코드와 함께 읽을 수 있습니다. `main` 브랜치에 푸시될 때마다 GitHub Actions가 자동으로 다시 배포합니다.
- **Xcode에서 보기**: 아래 [빌드하기](#빌드하기)대로 프로젝트를 연 뒤 **Product ▸ Build Documentation**(⌃⇧⌘D)을 실행하면 Xcode 문서 창에서 같은 튜토리얼을 볼 수 있습니다.

## 빌드하기

이 프로젝트는 `.xcodeproj`를 커밋하지 않고 `project.yml`로부터 생성합니다.

```bash
brew install xcodegen   # 최초 1회
cd ARDominoChainReaction
xcodegen generate
open ARDominoChainReaction.xcodeproj
```

## 완성본 받기

6장까지 완성된 Xcode 프로젝트(xcodegen 없이 바로 열 수 있음)는 [ARDominoChainReaction-Final.zip](https://0sunset0.github.io/2026TechMap_tutorial/ARDominoChainReaction-Final.zip)에서 받을 수 있습니다. `main` 브랜치에 푸시될 때마다 GitHub Actions가 자동으로 새로 만듭니다.

## 저장소 구조

```
ARDominoChainReaction/
├── project.yml                     # XcodeGen 프로젝트 정의
├── Sources/ARDominoChainReaction/  # 6장까지 완성된 앱 코드와 domino.usdz
├── ARDominoChainReaction.docc/     # DocC 튜토리얼 (Chapters/, Resources/)
└── Docs/                           # 설계 문서와 작업 기록
```

## 참고 문서

- [결정 기록](ARDominoChainReaction/Docs/Decision-Log.md): 앱과 튜토리얼을 만들면서 내린 결정과 그 이유
- [SPEC](ARDominoChainReaction/Docs/SPEC.md): 앱의 목표, 범위, 마일스톤
