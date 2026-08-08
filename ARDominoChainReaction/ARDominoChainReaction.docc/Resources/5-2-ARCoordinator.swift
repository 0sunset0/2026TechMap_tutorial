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
    // 드래그가 시작된(.began) 순간 손가락 아래에 있던 도미노. 드래그가 끝날 때(.ended) 이 도미노에 힘을 줌
    private var draggedDomino: ModelEntity?
    // 임펄스 세기. 도미노 크기를 키우면 질량도 같이 커지므로, 실기 테스트하며 "너무 세다/약하다"에 따라
    // 이 값을 조정하면 됨 (1.5 → 4.0 → 5.0 → 3.0 순서로 확정)
    private let dominoPushStrength: Float = 3.0
    // 도미노 질량(kg). 자동 계산(.default) 대신 직접 지정 — 실기 테스트하며 조정
    private let dominoMass: Float = 0.7

    init(status: ARStatusModel) {
        self.status = status
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { continue }
            guard planeAnchor.alignment == .horizontal else { continue }

            if !hasDetectedPlane {
                hasDetectedPlane = true
                DispatchQueue.main.async { [weak self] in
                    self?.status.statusText = "평면 감지됨! 곧 도미노를 세울 수 있어요"
                }
            }

            DispatchQueue.main.async { [weak self] in
                self?.addPhysicsFloor(for: planeAnchor)
            }
        }
    }

    private func addPhysicsFloor(for planeAnchor: ARPlaneAnchor) {
        guard let arView = arView else { return }

        let floorAnchor = AnchorEntity(anchor: planeAnchor)

        let floor = Entity()
        floor.position = planeAnchor.center
        floor.components.set(CollisionComponent(shapes: [
            .generateBox(width: planeAnchor.planeExtent.width, height: 0.01, depth: planeAnchor.planeExtent.height)
        ]))
        floor.components.set(PhysicsBodyComponent(massProperties: .default, material: .default, mode: .static))

        floorAnchor.addChild(floor)
        arView.scene.addAnchor(floorAnchor)
    }

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

    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let arView = arView else { return }

        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: arView)
            draggedDomino = arView.entity(at: location) as? ModelEntity

        case .ended:
            guard let domino = draggedDomino else { return }
            draggedDomino = nil

            let screenDelta = recognizer.translation(in: arView)
            let dragDistance = sqrt(screenDelta.x * screenDelta.x + screenDelta.y * screenDelta.y)
            guard dragDistance > 20 else { return }

            let direction = pushDirection(forScreenDelta: screenDelta, in: arView)
            domino.applyLinearImpulse(direction * dominoPushStrength, relativeTo: nil)
            status.statusText = "도미노가 넘어졌어요! 옆 도미노로 이어지는지 확인해보세요"

        default:
            break
        }
    }

    private func pushDirection(forScreenDelta screenDelta: CGPoint, in arView: ARView) -> SIMD3<Float> {
        let cameraTransform = arView.cameraTransform.matrix

        let cameraRight = SIMD3<Float>(cameraTransform.columns.0.x, cameraTransform.columns.0.y, cameraTransform.columns.0.z)
        let cameraForward = -SIMD3<Float>(cameraTransform.columns.2.x, cameraTransform.columns.2.y, cameraTransform.columns.2.z)

        let rightXZ = normalize(SIMD3<Float>(cameraRight.x, 0, cameraRight.z))
        let forwardXZ = normalize(SIMD3<Float>(cameraForward.x, 0, cameraForward.z))

        let rightAmount = Float(screenDelta.x)
        let forwardAmount = Float(-screenDelta.y)

        return normalize(rightXZ * rightAmount + forwardXZ * forwardAmount)
    }

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
