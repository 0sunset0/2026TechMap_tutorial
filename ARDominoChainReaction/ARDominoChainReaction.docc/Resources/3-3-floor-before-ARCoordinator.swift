class ARCoordinator: NSObject, ARSessionDelegate {
    // 기존 프로퍼티와 다른 메서드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    private func addPhysicsFloor(for planeAnchor: ARPlaneAnchor) {
        guard let arView = arView else { return }

        let floorAnchor = AnchorEntity(anchor: planeAnchor)

        let floor = Entity()
        floor.position = planeAnchor.center
        floor.components.set(CollisionComponent(shapes: [
            .generateBox(width: planeAnchor.planeExtent.width, height: 0.01, depth: planeAnchor.planeExtent.height)
        ]))

        floorAnchor.addChild(floor)
        arView.scene.addAnchor(floorAnchor)
    }
}
