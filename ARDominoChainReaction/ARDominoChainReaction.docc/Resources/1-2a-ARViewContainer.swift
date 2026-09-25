import SwiftUI
import RealityKit
import ARKit

// UIViewRepresentable: UIKit 뷰(ARView)를 SwiftUI 안에 끼워 넣을 수 있게 해주는 어댑터 프로토콜
struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var status: ARStatusModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        return arView
    }

    // AR 세션에서 사용할 설정을 만들어 반환함
    private func makeSessionConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        return configuration
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(status: status)
    }
}
