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

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(status: status)
    }
}
