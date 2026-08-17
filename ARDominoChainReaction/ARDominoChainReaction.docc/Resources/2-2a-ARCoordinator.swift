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

    // 도미노 엔티티 조립 담당: mesh(모양) + 재질(겉모습)을 순서대로 붙임
    private func makeDominoEntity() -> ModelEntity {
        let mesh = MeshResource.generateBox(width: 0.08, height: 0.2, depth: 0.04)

        // PhysicallyBasedMaterial: metallic은 0으로 두어 환경 반사 없이도 자연스러운 광택이 나오게 함
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .red)
        material.roughness = .init(floatLiteral: 0.4)
        material.metallic = .init(floatLiteral: 0.0)

        let domino = ModelEntity(mesh: mesh)
        return domino
    }
}
