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
        }
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
