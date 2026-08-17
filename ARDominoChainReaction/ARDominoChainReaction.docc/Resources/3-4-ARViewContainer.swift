import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var status: ARStatusModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let configuration = makeSessionConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = context.coordinator

        configureDebugOptions(for: arView)
        setupTapGesture(on: arView, coordinator: context.coordinator)
        context.coordinator.arView = arView

        return arView
    }

    private func makeSessionConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }

        return configuration
    }

    private func configureDebugOptions(for arView: ARView) {
        arView.debugOptions = [.showFeaturePoints]
    }

    // 제스처 등록 담당: 화면 탭을 감지해서 Coordinator로 이벤트를 넘겨주는 연결만 책임짐
    private func setupTapGesture(on arView: ARView, coordinator: ARCoordinator) {
        let tapGesture = UITapGestureRecognizer(
            target: coordinator,
            action: #selector(ARCoordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(status: status)
    }
}
