class ARCoordinator: NSObject, ARSessionDelegate {
    // 기존 코드 생략 — 아래에 표시하지 않은 프로퍼티와 메서드는 그대로 유지하세요.

    private let dominoSize = SIMD3<Float>(0.08, 0.2, 0.04)
    private let dominoMass: Float = 0.7

    private func makeDominoEntity() -> ModelEntity {
        let domino = try! ModelEntity.loadModel(named: "domino")

        domino.generateCollisionShapes(recursive: true)
        domino.components.set(PhysicsBodyComponent(massProperties: .init(mass: dominoMass), material: .default, mode: .dynamic))

        return domino
    }

    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)

        // 코드의 가정만으로는 정확한 값을 알 수 없어서, 실제 로드된 모델의 바운딩 박스를 직접 확인함
        let bounds = domino.visualBounds(relativeTo: nil)

        domino.position = SIMD3<Float>(0, bounds.extents.y / 2, 0)

        anchorEntity.addChild(domino)
        arView.scene.addAnchor(anchorEntity)
    }
}
