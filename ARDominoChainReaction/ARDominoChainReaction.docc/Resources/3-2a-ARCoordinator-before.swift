class ARCoordinator: NSObject, ARSessionDelegate {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    private var hasDetectedPlane = false

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            // as?: ARAnchor 중에서 "평면"으로 인식된 것만 걸러냄 (다른 종류의 앵커는 무시)
            guard let planeAnchor = anchor as? ARPlaneAnchor else { continue }
            guard planeAnchor.alignment == .horizontal else { continue }

            if !hasDetectedPlane {
                hasDetectedPlane = true
                // 델리게이트 콜백은 메인 스레드가 아닐 수 있어서, UI(배너 텍스트) 갱신은
                // 반드시 DispatchQueue.main.async로 감싸서 메인 스레드에서 실행함
                DispatchQueue.main.async { [weak self] in
                    self?.status.statusText = "평면 감지됨! 곧 도미노를 세울 수 있어요"
                }
            }
        }
    }
}
