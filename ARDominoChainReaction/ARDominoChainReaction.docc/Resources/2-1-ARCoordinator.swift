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
        // generateBox(width:height:depth:)는 너비를 X축, 높이를 Y축, 깊이를 Z축 길이로 갖는
        // 직육면체를 원점 중심에 만듦. height를 depth보다 크게 주면 이 mesh는 처음부터 세로로
        // "서 있는" 모양이 되므로, place(_:at:in:)에서 따로 세우는 회전을 넣지 않아도 됨
        let mesh = MeshResource.generateBox(width: 0.08, height: 0.2, depth: 0.04)
        let domino = ModelEntity(mesh: mesh)
        return domino
    }
}
