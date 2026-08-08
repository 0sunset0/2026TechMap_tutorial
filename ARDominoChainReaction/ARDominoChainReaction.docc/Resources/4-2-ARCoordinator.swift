    private var draggedDomino: ModelEntity?

    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let arView = arView else { return }

        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: arView)
            // entity(at:): 화면 좌표 아래에 있는 엔티티를 히트 테스트로 찾음. 물리 바닥은 ModelEntity가
            // 아니라서(빈 Entity) 캐스팅에 실패해 자동으로 걸러지고, 도미노를 짚었을 때만 값이 들어옴
            draggedDomino = arView.entity(at: location) as? ModelEntity

        case .ended:
            break

        default:
            break
        }
    }
