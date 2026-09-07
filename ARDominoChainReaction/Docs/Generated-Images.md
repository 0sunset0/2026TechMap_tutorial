# 튜토리얼 생성 이미지

생성 도구: built-in `image_gen` (2026-09-08). 모든 그림은 AI 생성 개념 예시이며 실기 캡처가 아닙니다. 나무 모델 그림은 제공 USDZ 파일의 정확한 렌더링이 아닙니다.

저장 위치: `ARDominoChainReaction.docc/Resources/`

## feature-points-illustration.png

프롬프트:

```text
Educational editorial 3D illustration for an AR programming tutorial. Wide landscape 3:2. Camera-view-like view of an empty real oak desk in a softly lit room with a book and plant in background; small bright yellow feature-point dots sparsely attached to visually distinctive desk corners, wood texture and book edges. No dominoes yet. Show spatial tracking visually, no connecting mesh, no plane grid. Clean realistic materials with subtly illustrative rendering. No phone frame, no UI, no text, no logos. This is a conceptual illustration, not a screenshot.
```

## people-occlusion-illustration.png

프롬프트:

```text
Educational 3D illustration, landscape 3:2, two equal side-by-side panels separated by thin white gutter, identical camera angle and scene. A tall thin plain red rectangular domino stands on pale oak desk; a human hand with natural anatomy held horizontally in foreground partially overlaps middle of domino. LEFT panel deliberately incorrect AR occlusion: the red domino renders over the overlapping hand, as if AR object ignores hand depth. RIGHT panel correct occlusion: the foreground hand hides middle of the red domino; top and bottom remain visible above and below the hand. Hand clearly nearer viewer in both panels. Minimal softly lit background, realistic but clearly illustrative. No text, no UI, no logos, no extra objects. Comparison of disabled vs enabled people occlusion.
```

검수 후 왼쪽 패널의 가림 표현을 다음 프롬프트로 수정했습니다:

```text
Edit only the LEFT panel of this two-panel educational comparison. The left red vertical rectangle MUST be rendered as a continuous opaque red block IN FRONT OF the hand: paint the entire vertical red domino silhouette from its top to its bottom OVER the middle of the fingers, completely hiding the fingers wherever the rectangle intersects them. This deliberately depicts INCORRECT AR compositing when occlusion is disabled. Keep right panel exactly unchanged: hand hides middle of red block correctly. Keep composition, lighting, desk and hand outside left domino silhouette. No text.
```

## tap-placement-illustration.png

프롬프트:

```text
Educational polished 3D illustration for AR domino tutorial, landscape 3:2. Six identical plain red thin rectangular domino blocks stand upright in a straight evenly spaced row on pale oak tabletop. Each has proportions width 8 height 20 depth 4; row extends along thin depth direction so toppling can propagate. Three-quarter view, all six fully visible, all bottoms rest on table, small gaps less than height. At empty next position a subtle circular touch marker suggests where to tap next. Soft natural light and quiet room background. No hands, no phone frames, no text, no pips or markings on red blocks, no arrows, no UI. Illustrative rendering, not claimed as screenshot.
```

## chain-reaction-illustration.png

프롬프트:

```text
Educational polished 3D illustration of physically plausible domino chain reaction on pale oak desk, landscape 3:2. Eight identical plain red slender rectangular blocks in a single straight row, row runs left foreground to right background along thin-depth direction. Leftmost blocks already lying down, middle blocks progressively leaning into next neighbor, last three still upright. Domino spacing less than block height so tilted blocks contact neighbors; clean visible contact sequence, gravity grounded, nothing floating or exploding. Each block proportions width 8 height 20 depth 4. Soft daylight, quiet background. No hands, no text, no motion arrows, no phone, no UI, no pips. Instructional 3D illustration rather than screenshot.
```

## mesh-usdz-comparison-illustration.png

프롬프트:

```text
Educational editorial 3D comparison illustration, landscape 3:2. Two equal panels separated by thin white gutter. Identical camera angle, pale oak tabletop and soft lighting. LEFT one upright plain red rectangular box domino with clean sharp edges and no markings. RIGHT one upright wooden domino with softly beveled edges, warm natural wood grain and dark inset round domino pips. Same outer proportions width 8 height 20 depth 4 and same placement/scale in both panels. Full objects visible with ample margins. Purpose compare procedural red box mesh with a detailed wooden USDZ asset; artistic conceptual example, not exact asset reproduction. No labels, no text, no UI, no logos, no arrows.
```


## 실제 USDZ 렌더링으로 교체

`mesh-usdz-comparison-illustration.png`는 실제 모델과 형태가 달라 사용을 중단했습니다. 튜토리얼 표지, 목차 썸네일, 본문은 `mesh-usdz-actual-comparison.png`를 사용합니다. Blender에서 저장소의 `Sources/ARDominoChainReaction/domino.usdz`를 직접 가져와 원본 메시와 재질을 유지하고, 세워진 방향과 조명·카메라를 설정해 렌더링했습니다. 원본에는 점 무늬와 베벨이 없습니다.


## xcode-usdz-import.png

내장 image_gen으로 생성한 Step 3 파일 추가 예시. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-usdz-import.png`.

프롬프트:

```text
Create a clean instructional UI illustration for a Korean Xcode tutorial, landscape 1536x1024. Show a simplified macOS Xcode project navigator on the left and a small Finder file area on the right. Light theme, crisp readable typography, neutral gray chrome, restrained blue selection highlight. The Xcode navigator tree must read exactly with indentation: top project "ARDominoChainReaction", child folder "Sources", nested folder "ARDominoChainReaction", with Swift files nested below: "ARCoordinator.swift", "ARViewContainer.swift", "ContentView.swift". The inner ARDominoChainReaction folder directly under Sources is highlighted blue as drop target, not the top-level project. Right area contains one file icon named exactly "domino.usdz". A curved blue arrow starts at that right-side file and points LEFT directly at the highlighted inner folder row. A translucent dragged copy of the domino.usdz icon with a small green plus badge sits near the arrow endpoint. Include modest English labels "Xcode" above left area and "Finder" above right area. Leave generous whitespace, show complete tree labels without truncation. No code editor needed, no inspector, no Target Membership controls, no dialog, no Korean text, no decorative graphics, no striped background. This is a focused instructional illustration of drag-and-drop destination, not a detailed replica of a particular Xcode release.
```



## xcode-target-membership.png

내장 image_gen으로 생성한 Step 4 타겟 멤버십 예시. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-target-membership.png`.

프롬프트:

```text
Create a focused instructional Xcode UI illustration for a programming tutorial, landscape 1536x1024, light theme, crisp legible typography. Show simplified Xcode window with project navigator on LEFT and File Inspector on RIGHT. Left tree: project "ARDominoChainReaction", nested folder "Sources", nested folder "ARDominoChainReaction", selected file "domino.usdz" highlighted blue. Center is quiet empty pale gray editor space, no invented 3D model preview. Right File Inspector has document icon selected at top, title "File Inspector", section "Identity and Type" with "Name" and value "domino.usdz". Below it expanded section headed exactly "Target Membership". Beneath this is a clearly CHECKED blue square checkbox with white checkmark, followed by exact app target name "ARDominoChainReaction". Give right pane enough width so name fits without truncation. Add a thin blue rounded rectangle callout around this Target Membership section and one small blue arrow pointing at checked checkbox. Readability and exact spelling are essential. No modal, no Add to targets dialog, no other checkboxes, no Korean text, no decorative stripes, no extra banners, no warning messages. This is a simplified explanatory illustration of File Inspector target membership, not an exact screenshot of a specific Xcode release.
```



## xcode-ios-app-template.png

내장 image_gen으로 생성한 프로젝트 준비 Step 1 예시. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-ios-app-template.png`.

프롬프트:

```text
Create a clean instructional Xcode new project template chooser UI illustration, landscape 1536x1024, light macOS theme, crisp readable typography. A single centered rounded macOS dialog, title exactly "Choose a template for your new project:". Across upper area tabs "Multiplatform", "iOS", "macOS", "watchOS", "tvOS", "visionOS"; iOS visibly selected with blue highlight. Below section label "Application". A template grid contains three clearly separated tiles: "App", "Document App", "Game". The FIRST tile "App" is selected with pale blue rounded rectangular background and distinct blue border, showing a simple blue application icon. Other tiles neutral gray. Two subtle blue callout arrows only: one points to selected iOS tab and another to selected App tile. Bottom left "Cancel", bottom right prominent blue enabled "Next" button. No editor, no project options form, no code, no AR template, no extra text, no Korean lettering. Plenty of whitespace, all words correctly spelled and fully visible. Focus is selecting iOS platform and standard App template. Simplified instructional illustration, not exact screenshot of a specific Xcode release.
```



## xcode-project-options.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-project-options.png`.

프롬프트:

```text
Clean instructional Xcode new project options dialog illustration, landscape 1536x1024, light macOS style matching a minimal tutorial screenshot illustration. Single centered rounded dialog titled "Choose options for your new project:". Large legible form with exact rows: "Product Name:" text field "ARDominoChainReaction"; "Team:" dropdown "None"; "Organization Identifier:" text field "com.example"; "Bundle Identifier:" read-only value "com.example.ARDominoChainReaction"; "Interface:" dropdown "SwiftUI"; "Language:" dropdown "Swift". Optional last row "Storage:" dropdown "None". Blue thin outlines emphasize only Product Name, Interface and Language fields, with subtle small blue arrows pointing at these three fields. Bottom buttons "Cancel" left, "Previous" and enabled blue "Next" right. Generous spacing, readable exact spelling, no truncated text, no code, no logos beyond ordinary window chrome, no Korean text, no striped background. Simplified instructional example, not a version-exact screenshot.
```


## xcode-project-save.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-project-save.png`.

프롬프트:

```text
Clean instructional macOS save-location sheet for creating an Xcode project, landscape 1536x1024, light theme matching minimal tutorial UI illustrations. A centered wide rounded file chooser. Title "Choose a location for your project". Top location field "Where:" with selected folder "Developer". Left sidebar with "Favorites", "Desktop", "Documents", "Downloads"; "Documents" selected. Main area breadcrumb "Documents > Developer", a clean mostly empty folder list with heading "Name", no existing project file, no private paths or usernames. Below main area show unchecked checkbox "Create Git repository on my Mac". Bottom "Cancel" left and prominent enabled blue "Create" button right. A thin blue outline emphasizes selected Developer location field and a clear small blue arrow points directly to Create. Large crisp readable text. No Product Name field, no filename extension, no code, no Korean text, no decorative background. Simplified instructional example of selecting a destination and pressing Create, not a version-exact screenshot.
```



## domino-chain-reaction.gif

표지 대표 이미지를 실제 `domino.usdz` 메시·재질을 사용한 Blender 애니메이션으로 교체했습니다. 도미노 8개의 회전을 순차적으로 조절한 연출이며 앱의 물리 시뮬레이션 녹화는 아닙니다. 800×450, 56프레임, 약 5.6초 반복. macOS ImageIO로 GIF를 인코딩했습니다.


## xcode-select-project.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-select-project.png`.

프롬프트:

```text
Create instructional Xcode UI illustration, landscape 1536x1024, crisp light macOS theme, readable exact labels. Left project navigator has TOP BLUE PROJECT ICON row named ARDominoChainReaction selected blue. Below it nested folder Sources then nested folder ARDominoChainReaction and files ContentView.swift, ARCoordinator.swift. A blue arrow points directly to TOP project row and thin blue outline around that row. Large central editor blank neutral gray. Focus only selecting blue project file at very top, not folder. No code, no other callouts, no Korean text. Simplified tutorial UI.
```


## xcode-select-app-target.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-select-app-target.png`.

프롬프트:

```text
Create instructional Xcode project settings UI illustration, landscape 1536x1024, light macOS theme, crisp readable exact text. Left narrow project navigator top blue project icon ARDominoChainReaction. Next central settings sidebar clearly shows two headings PROJECT and TARGETS. Under PROJECT one unselected project icon row ARDominoChainReaction. Under TARGETS one app icon row ARDominoChainReaction SELECTED BLUE. Make sidebar wide enough for exact full app name. Blue callout rectangle and arrow emphasize only selected row UNDER TARGETS. Editor right mostly blank pale gray. Critical PROJECT row unselected and TARGETS row selected, both clearly visible. No code, no Korean text, no extra arrows. Simplified instructional UI.
```


## xcode-target-info-tab.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-target-info-tab.png`.

프롬프트:

```text
Create instructional Xcode target settings illustration landscape 1536x1024 light macOS style crisp readable typography. Narrow left settings sidebar headings PROJECT with ARDominoChainReaction unselected and TARGETS with ARDominoChainReaction selected blue. Right main panel top tab bar exact labels General, Signing & Capabilities, Resource Tags, Info, Build Settings, Build Phases. Info selected blue and emphasized with blue rounded outline and small blue arrow. Beneath tabs heading Custom iOS Target Properties and table header Key, Type, Value with a few neutral empty rows. Focus clicking Info for selected app target. No code, no Korean text, no other callouts. Simplified educational UI.
```


## xcode-camera-usage-key.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-camera-usage-key.png`.

프롬프트:

```text
Create close-up instructional Xcode Info tab UI illustration landscape 1536x1024 light macOS theme crisp large readable text. Top selected tab Info. Heading Custom iOS Target Properties. Table columns Key, Type, Value. Show active NEW key row with small plus button at its left and editable Key field. A suggestion dropdown anchored below Key field has exact selected blue option Privacy - Camera Usage Description. Its Type is String, Value empty. Emphasize small + button with thin blue circle and emphasize selected Privacy - Camera Usage Description option with blue outline. Below table a modest explanatory mapping caption exactly Privacy - Camera Usage Description then a right arrow then NSCameraUsageDescription, text large and legible; wrap into two lines if necessary without truncating either key name. No permission alert, no code editor, no other privacy keys, no Korean text, no large extraneous arrows. Simplified educational UI showing adding a camera permission key, not a screenshot of a specific release.
```


## arkit-real-device.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/arkit-real-device.png`.

프롬프트:

```text
Educational tutorial illustration landscape 1536x1024, clean bright white background consistent with minimal technical tutorial art. A realistic older iPhone with circular home button standing upright at three-quarter angle, screen showing plain wooden desk with one unmarked red rectangular virtual domino. Beside phone a simple processor chip icon labeled exactly A9, and a camera lens symbol. Header exactly ARKit on iPhone. Small secondary label exactly A9 or later. Crisp understated blue accents, soft shadows, premium clear composition, no specific model names, no modern face ID phone, no pips on domino, no fake app controls, no Korean text. This illustrates ARKit hardware baseline, not OS compatibility or a device recommendation.
```


## arkit-device-vs-simulator.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/arkit-device-vs-simulator.png`.

프롬프트:

```text
Educational comparison illustration landscape 1536x1024, two equal panels on white background with thin gray divider, clean readable typography and blue accents. LEFT title Real device: a physical smartphone with wooden desk and plain red rectangular AR domino on screen. Below two distinct simple icons labeled Camera frames and Motion sensors, each with a blue checkmark; arrows from icons toward phone. RIGHT title Simulator: laptop screen containing empty phone simulator window with light gray blank display. Below matching icons labeled Camera frames and Motion sensors, each gray and crossed with subtle red slash indicating unavailable inputs for this AR tutorial. Footer centered exact text AR world tracking requires a real device. No claims that all simulator functions fail, no elaborate UI, no specific iPhone model, no Korean lettering, no pips on domino. Clear instructional infographic, not a screenshot.
```



## xcode-camera-usage-value.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-camera-usage-value.png`.

프롬프트:

```text
Create a very clear instructional Xcode Info table close-up, landscape 1536x1024, light macOS theme, crisp large readable typography, white background. Top small selected tab "Info", then heading "Custom iOS Target Properties". Table with THREE columns labeled exactly "Key", "Type", "Value", widths 48%, 12%, 40%. ONE row: Key reads exactly "Privacy - Camera Usage Description" (may wrap within cell if needed), Type reads exactly "String", Value is an EMPTY editable cell with thin bright blue focus outline and a visible text insertion cursor at its left. No dropdown menu is open. A large but restrained blue arrow points directly at EMPTY VALUE CELL from below. Beneath arrow a concise Korean instruction exactly "여기를 더블 클릭해 권한 요청 문구 입력". Make the Value header and empty Value cell unambiguous. No plus button highlight, no code snippet, no NSCameraUsageDescription mapping, no new-key dropdown, no other rows, no warnings, no phone, no extra UI. Generous whitespace. Simplified educational interface illustration matching clean prior Xcode tutorial images. Exact spelling essential.
```



## xcode-camera-usage-value-filled.png

내장 image_gen으로 기존 Value 칸 이미지를 편집하여 지정된 문구를 채웠습니다. Step 5는 이 이미지를 사용합니다. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-camera-usage-value-filled.png`.

편집 프롬프트:

```text
Edit this instructional image. Keep light Xcode Info table style, Info selected, heading, Key / Type / Value headers, exact key Privacy - Camera Usage Description, type String, blue focus outline and blue arrow. Replace the EMPTY Value field with the following EXACT Korean text, no quotation marks: AR 도미노 체인리액션에서 ARKit 카메라 트래킹을 사용하기 위해 카메라 접근 권한이 필요합니다. Make Value column wider and row taller as needed to show the ENTIRE text legibly wrapped across 3 or 4 lines within the blue bordered cell. Key can wrap into two lines to save horizontal space. All Korean characters must be correct with no truncation or ellipsis. Change bottom blue instructional caption to exactly "위 문구를 그대로 입력하세요". Preserve uncluttered composition, 1536x1024 landscape, no other changes.
```



## camera-permission-missing.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/camera-permission-missing.png`.

프롬프트:

```text
Educational diagram landscape 1536x1024 white background clean blue accents matching Xcode tutorial illustrations. Three large stages left to right: a document icon labeled NSCameraUsageDescription with a red missing marker and Korean caption "권한 문구 누락"; blue arrow to a camera icon caption "카메라 접근 시도"; blue arrow to a simple phone with a stopped app symbol and caption "앱 종료". Bottom short Korean sentence exactly "카메라를 사용하기 전에 권한 요청 문구를 설정하세요." Typography crisp and legible. Do not fabricate console logs or system error dialogs. No code, no actual crash screenshot, no other text. Minimal clear explanatory infographic.
```


## xcode-arkit-capability.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-arkit-capability.png`.

프롬프트:

```text
Instructional Xcode Info tab close-up landscape 1536x1024 light macOS style white background crisp readable labels. Selected tab Info, heading Custom iOS Target Properties. Table columns Key, Type, Value. Parent row expanded with disclosure triangle: Key Required device capabilities, Type Array, Value (1 item). Indented child row beneath: Key Item 0, Type String, Value arkit. Blue outline around child Value arkit and subtle arrow toward it. Below one concise Korean caption "배열을 펼치고 Item 0에 arkit을 입력하세요". Show exact spelling. No code snippets, no camera permission row, no extra UI. Simplified instructional depiction of array property editing.
```


## xcode-full-screen.png

내장 image_gen으로 생성. 저장 위치: `ARDominoChainReaction.docc/Resources/xcode-full-screen.png`.

프롬프트:

```text
Instructional Xcode Info tab close-up landscape 1536x1024 light macOS style white background crisp readable labels. Selected tab Info, heading Custom iOS Target Properties. Table columns Key, Type, Value. Single row Key Requires full screen, Type Boolean, Value YES. Value YES is clearly selected in editable dropdown, blue outlined focus and blue arrow to it. Below concise Korean caption "Requires full screen 값을 YES로 설정하세요". No code snippets, no simulator, no other properties, no checkbox that could conflict with YES. Exact labels and clean readable instructional UI.
```
