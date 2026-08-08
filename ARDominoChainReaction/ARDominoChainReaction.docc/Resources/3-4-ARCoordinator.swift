    // 감지 담당: 탭 좌표를 3D 공간 좌표로 변환하는 raycast만 책임짐.
    // .estimatedPlane: ARKit이 아직 정식으로 확정하지 못한 평면 추정치도 포함해서 검사 범위를 넓힘
    private func raycastResult(for recognizer: UITapGestureRecognizer, in arView: ARView) -> ARRaycastResult? {
        let tapLocation = recognizer.location(in: arView)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        return results.first
    }
