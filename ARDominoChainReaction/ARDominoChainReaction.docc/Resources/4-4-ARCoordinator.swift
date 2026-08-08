import UIKit
import RealityKit
import ARKit
import simd

class ARCoordinator: NSObject, ARSessionDelegate {
    weak var arView: ARView?
    let status: ARStatusModel
    private var hasDetectedPlane = false
    private var placedDominoes: [ModelEntity] = []
    // 드래그가 시작된(.began) 순간 손가락 아래에 있던 도미노. 드래그가 끝날 때(.ended) 이 도미노에 힘을 줌
    private var draggedDomino: ModelEntity?

    private let dominoSize = SIMD3<Float>(0.08, 0.2, 0.04)
    private let dominoMass: Float = 0.7
    // 임펄스 세기. 실기 테스트하면서 1.5 → 4.0 → 5.0 → 3.0 순서로 값을 바꿔가며 확정함
    private let dominoPushStrength: Float = 3.0

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

    private func makeDominoEntity() -> ModelEntity {
        let mesh = MeshResource.generateBox(width: dominoSize.x, height: dominoSize.y, depth: dominoSize.z)

        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .red)
        material.roughness = .init(floatLiteral: 0.4)
        material.metallic = .init(floatLiteral: 0.0)

        let domino = ModelEntity(mesh: mesh, materials: [material])

        domino.generateCollisionShapes(recursive: true)
        domino.components.set(PhysicsBodyComponent(massProperties: .init(mass: dominoMass), material: .default, mode: .dynamic))

        return domino
    }

    private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)

        domino.position = SIMD3<Float>(0, dominoSize.y / 2, 0)

        anchorEntity.addChild(domino)
        arView.scene.addAnchor(anchorEntity)
    }
}
