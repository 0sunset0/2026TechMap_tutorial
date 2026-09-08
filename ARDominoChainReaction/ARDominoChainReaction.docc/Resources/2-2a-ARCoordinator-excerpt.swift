class ARCoordinator: NSObject, ARSessionDelegate {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    private func makeDominoEntity() -> ModelEntity {
        let mesh = MeshResource.generateBox(width: 0.08, height: 0.2, depth: 0.04)

        // PhysicallyBasedMaterial: metallic은 0으로 두어 환경 반사 없이도 자연스러운 광택이 나오게 함
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .red)
        material.roughness = .init(floatLiteral: 0.4)
        material.metallic = .init(floatLiteral: 0.0)

        let domino = ModelEntity(mesh: mesh)
        return domino
    }
}
