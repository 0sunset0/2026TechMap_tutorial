struct ARViewContainer: UIViewRepresentable {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

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
}
