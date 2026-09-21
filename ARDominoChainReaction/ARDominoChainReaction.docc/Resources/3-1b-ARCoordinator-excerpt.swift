class ARCoordinator: NSObject, ARSessionDelegate {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    private var hasDetectedPlane = false

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { continue }
            guard planeAnchor.alignment == .horizontal else { continue }

            if !hasDetectedPlane {
                hasDetectedPlane = true
                DispatchQueue.main.async { [weak self] in
                    self?.status.statusText = "평면 감지됨! 곧 도미노를 세울 수 있어요"
                }
            }
        }
    }
}
