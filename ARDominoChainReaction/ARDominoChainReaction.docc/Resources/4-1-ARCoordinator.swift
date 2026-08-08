    // 드래그가 시작된(.began) 순간 손가락 아래에 있던 도미노. 드래그가 끝날 때(.ended) 이 도미노에 힘을 줌
    private var draggedDomino: ModelEntity?

    // 화면을 드래그했을 때 호출됨: 드래그가 시작된 지점의 도미노를 기억해뒀다가,
    // 드래그가 끝나면 그 도미노에 드래그 방향으로 임펄스(힘)를 가해 넘어뜨림
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let arView = arView else { return }

        switch recognizer.state {
        case .began:
            break

        case .ended:
            break

        default:
            break
        }
    }
