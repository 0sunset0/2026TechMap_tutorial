class ARCoordinator: NSObject, ARSessionDelegate {
    // 기존 프로퍼티와 메서드는 생략했습니다. 작성한 코드는 그대로 두세요.

    // 배치 담당: raycast로 얻은 위치/방향에 도미노를 실제로 씬에 등록함
    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)
    }
}
