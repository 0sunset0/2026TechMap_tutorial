import SwiftUI
import RealityKit
import ARKit

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
