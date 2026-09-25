# 스크린샷 체크리스트

`.tutorial` 파일의 스텝 중, 실제 화면이나 결과물을 보여주면 이해에 도움이 되는 곳들을 정리한 목록입니다.
캡처가 끝나면 `ARDominoChainReaction.docc/Resources/`에 파일을 넣고, 해당 스텝의 텍스트 뒤에
`@Image(source:alt:)`를 추가합니다.

지금은 대부분 설명용 그림으로 채워져 있습니다. 설명용 그림은 AI 생성 이미지나 3D 렌더이고, 각 그림의
프롬프트와 도구는 [Generated-Images.md](Generated-Images.md)에 있습니다. 실제 기기 캡처로 바꿀지는
항목마다 따로 판단합니다.

상태 표기:

- 실제 캡처: 실기기나 실제 화면을 담은 이미지가 들어가 있음
- 설명용 그림: 생성 이미지나 렌더로 채워져 있음. 실제 캡처로 바꾸는 건 선택
- 비어 있음: 아직 이미지가 없음

| 챕터 | 위치 | 지금 들어간 이미지 | 상태 |
| --- | --- | --- | --- |
| 1장 프로젝트 준비 | 카메라 권한 설정하기: 문구가 없으면 앱이 종료된다는 스텝 | `camera-permission-missing.png` | 설명용 그림 |
| 2장 기본 AR 씬 띄우기 | AR 세션 실행하기: 실기기 빌드 스텝(노란 특징점) | `feature-points-illustration.png` | 설명용 그림 |
| 3장 도미노 한 개 만들기 | 사람 뒤로 자연스럽게 가려지게 하기(People Occlusion 전후 비교) | `people-occlusion-proportions.png` | 설명용 그림 |
| 4장 탭으로 하나씩 배치하기 | 탭에 배치 로직 연결하기: 도미노가 한 줄로 선 모습 | `tap-placement-hero.png` | 설명용 그림 |
| 5장 드래그로 밀어 넘어뜨리기 | 마지막 스텝: 도미노가 연쇄적으로 쓰러지는 순간 | `finger-drag-domino-illustration.png`(미는 동작만 보여줌) | 비어 있음 |
| 6장 USDZ 모델로 다듬기 | 제공된 USDZ 에셋 다운로드하기: 모델 미리보기 | `domino-usdz-preview.png` | 설명용 그림 |
| 6장 USDZ 모델로 다듬기 | 제공된 USDZ 에셋 다운로드하기: 타겟 멤버십 체크 | `xcode-target-membership.png`(실제 화면 기반 재생성) | 설명용 그림 |
| 6장 USDZ 모델로 다듬기 | 실기기에서 비교 확인하기 | `domino-usdz-real-device.png` | 실제 캡처 |
| 튜토리얼 표지 | 완성된 앱이 동작하는 모습 | `domino-blender-demo.gif`(실기 녹화를 참고한 Blender 재현) | 설명용 그림 |

5장 마지막 스텝의 연쇄 반응 장면은 아직 없습니다. 지금 이미지는 손가락으로 미는 동작만 보여줍니다.
연쇄 반응 장면은 6장 마지막과 표지의 `domino-blender-demo.gif`에만 있습니다.
