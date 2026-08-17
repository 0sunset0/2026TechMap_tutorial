    // 배치 담당: raycast로 얻은 위치/방향에 도미노를 실제로 씬에 등록함
    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)
    }
