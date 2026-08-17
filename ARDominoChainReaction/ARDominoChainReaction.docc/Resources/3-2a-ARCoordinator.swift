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

            DispatchQueue.main.async { [weak self] in
                self?.addPhysicsFloor(for: planeAnchor)
            }
        }
    }

    // 물리 바닥 담당: 우선 감지된 평면에 그대로 붙는 빈 엔티티만 하나 올려봄
    private func addPhysicsFloor(for planeAnchor: ARPlaneAnchor) {
        guard let arView = arView else { return }

        // AnchorEntity(anchor:): ARPlaneAnchor에 직접 연결되는 앵커라서, ARKit이 평면 위치를
        // 갱신하면 앵커 자체는 자동으로 따라감
        let floorAnchor = AnchorEntity(anchor: planeAnchor)

        // Entity(): 화면에 안 보이는 빈 엔티티. 물리 바닥은 실제로 눈에 보일 필요가 없고
        // 충돌만 감지하면 되므로 ModelEntity(mesh 있음) 대신 이걸 씀
        let floor = Entity()

        floorAnchor.addChild(floor)
        arView.scene.addAnchor(floorAnchor)
    }
}
