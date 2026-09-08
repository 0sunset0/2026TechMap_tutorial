class ARCoordinator: NSObject, ARSessionDelegate {
    // 기존 코드 생략 — 아래에 표시하지 않은 프로퍼티와 메서드는 그대로 유지하세요.

    private let dominoMass: Float = 0.7

    private func makeDominoEntity() -> ModelEntity {
        // domino.usdz 안에 mesh와 나무 재질이 이미 담겨 있어서, 절차적으로 만들 필요가 없음.
        // 회전 없이 그대로 쓰면 세워진 상태가 되도록 Blender에서 로컬 Y축 = 높이로 모델링해둠
        let domino = try! ModelEntity.loadModel(named: "domino")

        // 충돌 shape: 도미노끼리 부딪히려면 반드시 필요함 (엔티티 자체의 속성이라 여기서 붙임)
        domino.generateCollisionShapes(recursive: true)
        // PhysicsBodyComponent(.dynamic): 중력을 받아 물리 바닥 위에 서고, 나중에 임펄스(힘)를 받으면
        // 실제로 넘어지고, 다른 도미노와 부딪히면 밀어내는 등 물리 시뮬레이션에 참여함.
        domino.components.set(PhysicsBodyComponent(massProperties: .init(mass: dominoMass), material: .default, mode: .dynamic))

        return domino
    }

    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)

        // mesh가 원점을 중심으로 만들어져 있어서, 회전 없이 그대로 놓으면 도미노의 절반이
        // 바닥 아래로 파묻힘. dominoSize 상수 대신 실제 로드된 모델의 바운딩 박스를 측정해서
        // 그 높이의 절반만큼 로컬 Y축으로 띄워야 모델 크기가 달라져도 항상 정확히 맞음
        let bounds = domino.visualBounds(relativeTo: nil)
        domino.position = SIMD3<Float>(0, bounds.extents.y / 2, 0)

        anchorEntity.addChild(domino)
        arView.scene.addAnchor(anchorEntity)
    }
}
