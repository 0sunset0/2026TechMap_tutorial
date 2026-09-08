import UIKit
import RealityKit
import ARKit
import simd

class ARCoordinator: NSObject, ARSessionDelegate {
    weak var arView: ARView?
    let status: ARStatusModel

    init(status: ARStatusModel) {
        self.status = status
    }

    // 도미노 엔티티 조립 담당: 우선 모양(mesh)만 만들어봄
    private func makeDominoEntity() -> ModelEntity {
        // height는 위아래 방향(Y축)의 길이, 즉 도미노의 높이입니다.
        // 너비 8cm, 깊이 4cm보다 높이를 20cm로 크게 잡아 세로로 긴 도미노를 만듭니다.
        // 처음부터 세워진 모양이므로, 세우기 위해 따로 회전할 필요가 없습니다.
        let mesh = MeshResource.generateBox(width: 0.08, height: 0.2, depth: 0.04)
        let domino = ModelEntity(mesh: mesh)
        return domino
    }
}
