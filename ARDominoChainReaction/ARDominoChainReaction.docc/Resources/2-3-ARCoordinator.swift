import UIKit
import RealityKit
import ARKit
import simd

class ARCoordinator: NSObject, ARSessionDelegate {
    weak var arView: ARView?
    let status: ARStatusModel

    private let dominoSize = SIMD3<Float>(0.08, 0.2, 0.04)
    // 도미노 질량(kg). 자동 계산(.default) 대신 직접 지정 — 실기 테스트하며 조정
    private let dominoMass: Float = 0.7

    init(status: ARStatusModel) {
        self.status = status
    }

    // 도미노 엔티티 조립 담당: mesh(모양) + 재질(겉모습) + 충돌 shape + 물리 바디를 순서대로 붙임
    private func makeDominoEntity() -> ModelEntity {
        let mesh = MeshResource.generateBox(width: dominoSize.x, height: dominoSize.y, depth: dominoSize.z)

        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: .red)
        material.roughness = .init(floatLiteral: 0.4)
        material.metallic = .init(floatLiteral: 0.0)

        let domino = ModelEntity(mesh: mesh, materials: [material])

        // 충돌 shape: 도미노끼리 부딪히려면 반드시 필요함 (엔티티 자체의 속성이라 여기서 붙임)
        domino.generateCollisionShapes(recursive: true)
        // PhysicsBodyComponent(.dynamic): 중력을 받아 물리 바닥 위에 서고, 나중에 임펄스(힘)를 받으면
        // 실제로 넘어지고, 다른 도미노와 부딪히면 밀어내는 등 물리 시뮬레이션에 참여함
        domino.components.set(PhysicsBodyComponent(massProperties: .init(mass: dominoMass), material: .default, mode: .dynamic))

        return domino
    }
}
