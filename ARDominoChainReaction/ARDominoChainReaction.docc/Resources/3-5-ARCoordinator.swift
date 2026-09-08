import UIKit
import RealityKit
import ARKit
import simd

class ARCoordinator: NSObject, ARSessionDelegate {
    weak var arView: ARView?
    let status: ARStatusModel
    private var hasDetectedPlane = false

    private let dominoSize = SIMD3<Float>(0.08, 0.2, 0.04)
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

            // 물리 바닥은 씬에 엔티티를 추가하는 작업이라 arView.scene에 접근해야 하고,
            // UIKit/RealityKit 관련 작업이므로 메인 스레드에서 실행함
            DispatchQueue.main.async { [weak self] in
                self?.addPhysicsFloor(for: planeAnchor)
            }
        }
    }

    // 물리 바닥 담당: ARKit이 실제로 감지한 평면에 보이지 않는 정적(static) 물리 바디를 붙여서,
    // 도미노가 그 위에 서고, 넘어지고, 서로 부딪힐 수 있게 함
    private func addPhysicsFloor(for planeAnchor: ARPlaneAnchor) {
        guard let arView = arView else { return }

        // AnchorEntity(anchor:): ARPlaneAnchor에 직접 연결되는 앵커라서, ARKit이 평면 위치를
        // 갱신하면 앵커 자체는 자동으로 따라감
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
    }

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

    // 감지 담당: 탭 좌표를 3D 공간 좌표로 변환하는 raycast만 책임짐.
    // .estimatedPlane: ARKit이 아직 정식으로 확정하지 못한 평면 추정치도 포함해서 검사 범위를 넓힘
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
}
