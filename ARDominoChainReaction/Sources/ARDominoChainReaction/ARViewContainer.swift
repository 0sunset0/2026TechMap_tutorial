import SwiftUI
import RealityKit
import ARKit

// UIViewRepresentable: UIKit 뷰(ARView)를 SwiftUI 안에 끼워 넣을 수 있게 해주는 어댑터 프로토콜
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

    // 세션 설정 담당: 도미노는 바닥/책상(수평면) 위에 세우므로 평면 감지만 켬
    private func makeSessionConfiguration() -> ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic

        // People Occlusion: 사람이 도미노보다 카메라에 더 가까이 있을 때, 도미노가 사람 뒤로
        // 자연스럽게 가려지도록 함. 기기가 지원하는지 먼저 확인한 뒤 켜야 안전함
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }

        return configuration
    }

    // 디버그 시각화 담당: 카메라가 인식한 특징점을 화면에 노란 점으로 표시해서,
    // 트래킹이 실제로 동작 중인지 눈으로 바로 확인할 수 있게 함
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
