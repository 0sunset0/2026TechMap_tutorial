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
        // generateBox(width:height:depth:)는 너비=로컬 X축, 높이=로컬 Y축, 깊이=로컬 Z축인
        // 직육면체를 원점 중심으로 만듦. 즉 이 mesh를 회전 없이 그대로 쓰면 "높이" 방향이
        // 로컬 Y축을 향함 — place(_:at:in:)에서 이 점을 활용해 별도 회전 없이 세움
        let mesh = MeshResource.generateBox(width: 0.08, height: 0.2, depth: 0.04)
        let domino = ModelEntity(mesh: mesh)
        return domino
    }
}
