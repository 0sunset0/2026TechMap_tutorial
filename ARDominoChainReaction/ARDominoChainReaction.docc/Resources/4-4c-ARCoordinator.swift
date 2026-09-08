class ARCoordinator: NSObject, ARSessionDelegate {
    // 기존 코드 생략 — 아래에 표시하지 않은 프로퍼티와 메서드는 그대로 유지하세요.

    // 드래그가 시작된(.began) 순간 손가락 아래에 있던 도미노. 드래그가 끝날 때(.ended) 이 도미노에 힘을 줌
    private var draggedDomino: ModelEntity?
    private let dominoPushStrength: Float = 3.0

    // 화면을 드래그했을 때 호출됨: 드래그가 시작된 지점의 도미노를 기억해뒀다가,
    // 드래그가 끝나면 그 도미노에 드래그 방향으로 임펄스(힘)를 가해 넘어뜨림
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let arView = arView else { return }

        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: arView)
            let domino = arView.entity(at: location) as? ModelEntity
            draggedDomino = domino

        case .ended:
            guard let domino = draggedDomino else { return }
            draggedDomino = nil

            let screenDelta = recognizer.translation(in: arView)
            let dragDistance = sqrt(screenDelta.x * screenDelta.x + screenDelta.y * screenDelta.y)
            // 20포인트 이하의 짧은 드래그는 무시합니다.
            guard dragDistance > 20 else { return }

        default:
            break
        }
    }
}
