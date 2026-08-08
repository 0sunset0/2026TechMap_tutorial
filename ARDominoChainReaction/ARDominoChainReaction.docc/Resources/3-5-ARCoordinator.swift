    // 배치 담당: raycast로 얻은 위치/방향에 도미노를 실제로 씬에 등록함
    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)

        // mesh가 원점을 중심으로 만들어져 있어서, 회전 없이 그대로 놓으면 도미노의 절반이
        // 바닥 아래로 파묻힘. 높이의 절반만큼 로컬 Y축으로 띄워서 바닥 위에 정확히 서게 함
        domino.position = SIMD3<Float>(0, dominoSize.y / 2, 0)

        anchorEntity.addChild(domino)
        arView.scene.addAnchor(anchorEntity)
    }
