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

            // 물리 바닥은 씬에 엔티티를 추가하는 작업이라 arView.scene에 접근해야 하고,
            // UIKit/RealityKit 관련 작업이므로 메인 스레드에서 실행함
            DispatchQueue.main.async { [weak self] in
                self?.addPhysicsFloor(for: planeAnchor)
            }
        }
    }

    private func addPhysicsFloor(for planeAnchor: ARPlaneAnchor) {
        guard let arView = arView else { return }

        // AnchorEntity(anchor:): ARPlaneAnchor에 직접 연결되는 앵커라서, ARKit이 평면 위치를
        // 갱신하면 앵커 자체는 자동으로 따라감
        let floorAnchor = AnchorEntity(anchor: planeAnchor)

        // Entity(): 화면에 안 보이는 빈 엔티티. 물리 바닥은 실제로 눈에 보일 필요가 없고
        // 충돌만 감지하면 되므로 ModelEntity(mesh 있음) 대신 이걸 씀
        let floor = Entity()

        floorAnchor.addChild(floor)
        arView.scene.addAnchor(floorAnchor)
    }
}
