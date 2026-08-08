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

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> ARCoordinator {
        ARCoordinator(status: status)
    }
}
