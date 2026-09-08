class ARCoordinator: NSObject, ARSessionDelegate {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    private var placedDominoes: [ModelEntity] = []

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        guard let result = raycastResult(for: recognizer, in: arView) else {
            status.statusText = "이 위치에는 평면이 없어요 — 감지된 평면 위를 탭해보세요"
            return
        }

        let domino = makeDominoEntity()
        place(domino, at: result.worldTransform, in: arView)
        placedDominoes.append(domino)

        status.statusText = "도미노 \(placedDominoes.count)개 배치됨 — 계속 탭해서 줄을 세워보세요"
    }
}
