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
        setupPanGesture(on: arView, coordinator: context.coordinator)
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

    private func setupTapGesture(on arView: ARView, coordinator: ARCoordinator) {
        let tapGesture = UITapGestureRecognizer(
            target: coordinator,
            action: #selector(ARCoordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
    }

    // 제스처 등록 담당: 화면 드래그(밀기)를 감지해서 Coordinator로 이벤트를 넘겨주는 연결만 책임짐.
    // UIPanGestureRecognizer를 쓰는 이유: RealityKit의 installGestures(.translation)는 엔티티를
    // 직접 옮겨버려서 물리 시뮬레이션과 충돌함 — 여기서는 "엔티티를 옮기는" 게 아니라
    // "화면 드래그 방향을 계산해서 임펄스를 가하는" 것이므로 UIKit 제스처로 직접 처리함
    private func setupPanGesture(on arView: ARView, coordinator: ARCoordinator) {
        let panGesture = UIPanGestureRecognizer(
            target: coordinator,
            action: #selector(ARCoordinator.handlePan(_:))
        )
        arView.addGestureRecognizer(panGesture)
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(status: status)
    }
}
