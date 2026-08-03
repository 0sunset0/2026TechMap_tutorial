# AR 도미노 체인리액션 튜토리얼

공간에 도미노를 여러 개 세워 배치하고, 하나를 밀면 물리 시뮬레이션으로 옆 도미노가 연쇄적으로 쓰러지는 ARKit + RealityKit 기반 AR 도미노 체인리액션 앱을 만드는 튜토리얼 저장소입니다.

## [`ARDominoChainReaction/`](ARDominoChainReaction/)

**요구 사항**
- Xcode 15 이상
- iOS 17.0 이상, A9 칩 이상 기기 (ARKit 월드 트래킹 최소 사양). People Occlusion까지 동작하려면 A12 칩 이상 필요
- 카메라가 없는 시뮬레이터에서는 AR 세션 실행 불가 — 실기 필요
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)

**빌드하기**

이 프로젝트는 `.xcodeproj`를 커밋하지 않고 `project.yml`로부터 생성합니다.

```bash
brew install xcodegen   # 최초 1회
cd ARDominoChainReaction
xcodegen generate
open ARDominoChainReaction.xcodeproj
```
