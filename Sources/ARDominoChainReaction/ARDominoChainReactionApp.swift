import SwiftUI

// @main: 이 구조체가 앱의 진입점(시작점)임을 iOS에 알려주는 표시. 프로젝트 전체에 딱 하나만 있어야 함
@main
struct ARDominoChainReactionApp: App {
    var body: some Scene {
        // WindowGroup: 앱 창을 하나 만들고, 그 안에 첫 화면으로 ContentView를 띄움
        WindowGroup {
            ContentView()
        }
    }
}
