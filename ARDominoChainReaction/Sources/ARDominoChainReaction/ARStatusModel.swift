import Foundation

// ObservableObject: 이 클래스의 상태가 바뀌면 구독 중인 SwiftUI 뷰들에게 자동으로 알려주는 프로토콜.
// 화면 상단 배너 텍스트를 여기서 관리해서, 코드 어디서든 "지금 뭘 하면 되는지"를 업데이트할 수 있게 함
final class ARStatusModel: ObservableObject {
    // @Published: 이 값이 바뀔 때마다 구독자(ContentView의 Text)가 자동으로 다시 그려짐
    @Published var statusText: String = "카메라로 바닥이나 책상을 천천히 비춰보세요"
}
