import UIKit
import RealityKit
import ARKit
import simd

// ARCoordinator: ARViewContainer(UIViewRepresentable)가 UIKit 이벤트(델리게이트 콜백, 제스처 등)를
// 받기 위한 중개자
class ARCoordinator: NSObject, ARSessionDelegate {
    weak var arView: ARView?
    let status: ARStatusModel
    private var hasDetectedPlane = false
    // 배치된 도미노 목록. 지금은 개수 표시에만 쓰지만, 이후 마일스톤(여러 개 줄세우기)에서도 유용해서 미리 추적해둠
    private var placedDominoes: [ModelEntity] = []
    // 평면 앵커의 identifier → 그 평면에 붙인 물리 바닥 엔티티. 평면이 넓어질 때(didUpdate)
    // 어떤 물리 바닥을 갱신해야 할지 찾기 위해 필요함
    private var physicsFloors: [UUID: Entity] = [:]
    // 드래그가 시작된(.began) 순간 손가락 아래에 있던 도미노. 드래그가 끝날 때(.ended) 이 도미노에 힘을 줌
    private var draggedDomino: ModelEntity?
    // 임펄스 세기. 도미노 크기를 키우면서 질량도 커졌기 때문에 값을 조정할 필요가 있을 수 있음 —
    // 실기 테스트하면서 "너무 세다/약하다"에 따라 이 값을 조정하면 됨
    private let dominoPushStrength: Float = 3.0
    // 도미노 질량(kg). 자동 계산(.default) 대신 직접 지정 — 실기 테스트하며 조정
    private let dominoMass: Float = 0.7

    init(status: ARStatusModel) {
        self.status = status
    }

    // ARKit이 새 앵커(예: 감지된 평면)를 추가할 때마다 자동으로 호출되는 델리게이트 메서드
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            // as?: ARAnchor 중에서 "평면"으로 인식된 것만 걸러냄 (다른 종류의 앵커는 무시)
            guard let planeAnchor = anchor as? ARPlaneAnchor else { continue }
            guard planeAnchor.alignment == .horizontal else { continue }

            if !hasDetectedPlane {
                hasDetectedPlane = true
                // 델리게이트 콜백은 메인 스레드가 아닐 수 있어서, UI(배너 텍스트) 갱신은
                // 반드시 DispatchQueue.main.async로 감싸서 메인 스레드에서 실행함
                DispatchQueue.main.async { [weak self] in
                    self?.status.statusText = "평면 감지됨! 곧 도미노를 세울 수 있어요"
                }
            }

            // 물리 바닥은 씬에 엔티티를 추가하는 작업이라 arView.scene에 접근해야 하고,
            // UIKit/RealityKit 관련 작업이므로 메인 스레드에서 실행함
            DispatchQueue.main.async { [weak self] in
                self?.addPhysicsFloor(for: planeAnchor)
            }
        }
    }

    // ARKit이 이미 추가된 평면(앵커)의 정보를 갱신할 때마다 호출됨.
    // 평면은 스캔이 진행될수록 감지 범위(planeExtent)가 넓어지는데, 물리 바닥을 처음 크기로
    // 고정해두면 나중에 넓어진 영역은 raycast로는 탭이 되지만 물리 바닥이 없어서 도미노가
    // 떨어지는 버그가 생김 — 그래서 매번 물리 바닥의 크기/위치를 최신 상태로 갱신해줌
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { continue }
            guard let floor = physicsFloors[planeAnchor.identifier] else { continue }

            DispatchQueue.main.async { [weak floor] in
                guard let floor = floor else { return }
                floor.position = planeAnchor.center
                floor.components.set(CollisionComponent(shapes: [
                    .generateBox(width: planeAnchor.planeExtent.width, height: 0.01, depth: planeAnchor.planeExtent.height)
                ]))
            }
        }
    }

    // 물리 바닥 담당: ARKit이 실제로 감지한 평면에 보이지 않는 정적(static) 물리 바디를 붙여서,
    // 도미노가 그 위에 서고, 넘어지고, 서로 부딪힐 수 있게 함
    private func addPhysicsFloor(for planeAnchor: ARPlaneAnchor) {
        guard let arView = arView else { return }

        // AnchorEntity(anchor:): ARPlaneAnchor에 직접 연결되는 앵커라서, ARKit이 평면 위치를
        // 갱신하면 앵커 자체는 자동으로 따라가지만, 그 안의 collision shape 크기는 자동으로
        // 안 바뀌므로 session(_:didUpdate:)에서 별도로 갱신해줌
        let floorAnchor = AnchorEntity(anchor: planeAnchor)

        // Entity(): 화면에 안 보이는 빈 엔티티. 물리 바닥은 실제로 눈에 보일 필요가 없고
        // 충돌만 감지하면 되므로 ModelEntity(mesh 있음) 대신 이걸 씀
        let floor = Entity()
        // planeAnchor.center: 앵커의 좌표 원점과 실제 감지된 평면의 중심은 다를 수 있어서,
        // 이 오프셋을 반영하지 않으면 물리 바닥이 실제 평면과 어긋난 위치에 생김
        floor.position = planeAnchor.center
        floor.components.set(CollisionComponent(shapes: [
            .generateBox(width: planeAnchor.planeExtent.width, height: 0.01, depth: planeAnchor.planeExtent.height)
        ]))
        // mode: .static — 절대 움직이지 않는 받침대. 도미노(.dynamic)가 이 위에서만 중력의 영향을 받음
        floor.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static))

        floorAnchor.addChild(floor)
        arView.scene.addAnchor(floorAnchor)

        // didUpdate에서 이 평면이 갱신될 때 어떤 floor 엔티티를 고쳐야 할지 찾을 수 있게 저장해둠
        physicsFloors[planeAnchor.identifier] = floor
    }

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

    // 화면을 드래그했을 때 호출됨: 드래그가 시작된 지점의 도미노를 기억해뒀다가,
    // 드래그가 끝나면 그 도미노에 드래그 방향으로 임펄스(힘)를 가해 넘어뜨림
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let arView = arView else { return }

        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: arView)
            // entity(at:): 화면 좌표 아래에 있는 엔티티를 히트 테스트로 찾음. 물리 바닥은 ModelEntity가
            // 아니라서(빈 Entity) 캐스팅에 실패해 자동으로 걸러지고, 도미노를 짚었을 때만 값이 들어옴
            draggedDomino = arView.entity(at: location) as? ModelEntity

        case .ended:
            guard let domino = draggedDomino else { return }
            draggedDomino = nil

            let screenDelta = recognizer.translation(in: arView)
            let dragDistance = sqrt(screenDelta.x * screenDelta.x + screenDelta.y * screenDelta.y)
            // 너무 짧은 드래그(실수로 살짝 스친 정도)는 무시함
            guard dragDistance > 20 else { return }

            let direction = pushDirection(forScreenDelta: screenDelta, in: arView)
            domino.applyLinearImpulse(direction * dominoPushStrength, relativeTo: nil)
            status.statusText = "도미노가 넘어졌어요! 옆 도미노로 이어지는지 확인해보세요"

        default:
            break
        }
    }

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

        // 화면 좌표는 아래로 갈수록 y가 커지므로(UIKit 좌표계), 위로 드래그(y가 음수)할 때
        // 카메라 정면 방향으로 힘이 가도록 부호를 뒤집음
        let rightAmount = Float(screenDelta.x)
        let forwardAmount = Float(-screenDelta.y)

        return normalize(rightXZ * rightAmount + forwardXZ * forwardAmount)
    }

    // 감지 담당: 탭 좌표를 3D 공간 좌표로 변환하는 raycast만 책임짐.
    // .estimatedPlane: ARKit이 아직 정식으로 확정하지 못한 평면 추정치도 포함해서 검사 범위를 넓힘
    private func raycastResult(for recognizer: UITapGestureRecognizer, in arView: ARView) -> ARRaycastResult? {
        let tapLocation = recognizer.location(in: arView)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        return results.first
    }

    // 도미노 엔티티 조립 담당: USDZ 모델(모양+재질) + 충돌 shape + 물리 바디를 순서대로 붙임
    private func makeDominoEntity() -> ModelEntity {
        // domino.usdz 안에 mesh와 나무 재질이 이미 담겨 있어서, 절차적으로 만들 필요가 없음.
        // 회전 없이 그대로 쓰면 세워진 상태가 되도록 Blender에서 로컬 Y축 = 높이로 모델링해둠
        let domino = try! ModelEntity.loadModel(named: "domino")

        // 충돌 shape: 도미노끼리 부딪히려면 반드시 필요함 (엔티티 자체의 속성이라 여기서 붙임)
        domino.generateCollisionShapes(recursive: true)
        // PhysicsBodyComponent(.dynamic): 중력을 받아 물리 바닥 위에 서고, 나중에 임펄스(힘)를 받으면
        // 실제로 넘어지고, 다른 도미노와 부딪히면 밀어내는 등 물리 시뮬레이션에 참여함.
        // massProperties: 자동 계산(.default) 대신 직접 질량(kg)을 지정해 튜닝함
        domino.components.set(PhysicsBodyComponent(massProperties: .init(mass: dominoMass), material: .default, mode: .dynamic))

        return domino
    }

    // 배치 담당: raycast로 얻은 위치/방향에 도미노를 실제로 씬에 등록함
    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)

        // mesh가 원점을 중심으로 만들어져 있어서, 회전 없이 그대로 놓으면 도미노의 절반이
        // 바닥 아래로 파묻힘. dominoSize 상수 대신 실제 로드된 모델의 바운딩 박스를 측정해서
        // 그 높이의 절반만큼 로컬 Y축으로 띄워야 모델 크기가 달라져도 항상 정확히 맞음
        let bounds = domino.visualBounds(relativeTo: nil)
        domino.position = SIMD3<Float>(0, bounds.extents.y / 2, 0)

        anchorEntity.addChild(domino)
        arView.scene.addAnchor(anchorEntity)
    }
}
