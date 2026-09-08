class ARCoordinator: NSObject, ARSessionDelegate {
    // 기존 코드 생략 — 아래에 표시하지 않은 프로퍼티와 메서드는 그대로 유지하세요.

    private let dominoSize = SIMD3<Float>(0.08, 0.2, 0.04)
    private let dominoMass: Float = 0.7

    private func makeDominoEntity() -> ModelEntity {
        // domino.usdz 안에 mesh와 나무 재질이 이미 담겨 있어서, 절차적으로 만들 필요가 없음.
        // 회전 없이 그대로 쓰면 세워진 상태가 되도록 Blender에서 로컬 Y축 = 높이로 모델링해둠
        let domino = try! ModelEntity.loadModel(named: "domino")

        return domino
    }

    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)

        domino.position = SIMD3<Float>(0, dominoSize.y / 2, 0)

        anchorEntity.addChild(domino)
        arView.scene.addAnchor(anchorEntity)
    }
}
