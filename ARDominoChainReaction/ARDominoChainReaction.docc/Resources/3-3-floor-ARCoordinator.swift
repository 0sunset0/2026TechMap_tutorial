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

        // .static: 중력이나 충돌에 움직이지 않는 물리 바닥으로 설정합니다.
        floor.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static))

        floorAnchor.addChild(floor)
        arView.scene.addAnchor(floorAnchor)
    }
}
