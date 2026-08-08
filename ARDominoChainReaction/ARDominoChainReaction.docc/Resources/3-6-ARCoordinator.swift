    // 배치된 도미노 목록. 지금은 개수 표시에만 쓰지만, 이후 마일스톤(체인리액션)에서도 유용해서 미리 추적해둠
    private var placedDominoes: [ModelEntity] = []

    // 화면을 탭했을 때 호출됨: 탭한 위치에 도미노를 하나 만들어 세워 배치함
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
