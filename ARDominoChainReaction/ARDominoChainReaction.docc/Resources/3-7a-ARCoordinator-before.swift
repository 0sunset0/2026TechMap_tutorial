class ARCoordinator: NSObject, ARSessionDelegate {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        guard let result = raycastResult(for: recognizer, in: arView) else {
            status.statusText = "이 위치에는 평면이 없어요 — 감지된 평면 위를 탭해보세요"
            return
        }

        let position = result.worldTransform.columns.3
        status.statusText = "평면을 찾았어요!"
        print("탭한 위치(m): x=\(position.x), y=\(position.y), z=\(position.z)")
    }
}
