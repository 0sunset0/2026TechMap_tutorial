class ARCoordinator: NSObject, ARSessionDelegate {
    // 기존 코드 생략 — 아래에 표시하지 않은 프로퍼티와 메서드는 그대로 유지하세요.

    // 화면에서의 드래그 벡터(2D, 스크린 좌표)를 카메라 방향 기준의 3D 수평 방향(월드 좌표)으로 변환함.
    // 예: 화면에서 오른쪽으로 밀면 카메라의 "오른쪽"으로, 위로 밀면 카메라의 "정면"으로 힘을 줌
    private func pushDirection(forScreenDelta screenDelta: CGPoint, in arView: ARView) -> SIMD3<Float> {
        let cameraTransform = arView.cameraTransform.matrix

        // 카메라 로컬 축을 world 좌표로 뽑아냄: column 0 = 카메라의 오른쪽, column 2 = 카메라의 뒤쪽
        // (카메라는 자신의 -Z 방향을 바라보므로, "정면"은 column 2에 -를 붙여야 함)
        let cameraRight = SIMD3<Float>(cameraTransform.columns.0.x, cameraTransform.columns.0.y, cameraTransform.columns.0.z)
        let cameraForward = -SIMD3<Float>(cameraTransform.columns.2.x, cameraTransform.columns.2.y, cameraTransform.columns.2.z)

        // 도미노는 바닥 위에서 수평으로만 밀리므로, Y(위아래) 성분은 버리고 XZ 평면에만 투영함
        let rightXZ = normalize(SIMD3<Float>(cameraRight.x, 0, cameraRight.z))
        let forwardXZ = normalize(SIMD3<Float>(cameraForward.x, 0, cameraForward.z))

        // 방향 계산은 다음 단계에서 완성합니다.
        return .zero
    }
}
