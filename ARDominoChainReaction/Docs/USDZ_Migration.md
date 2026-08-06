# 기록 — 절차적 mesh → USDZ 모델 교체

`ARCoordinator.swift`에서 도미노를 코드로 직접 그리던 방식(절차적 mesh)을, Blender에서 만든 `domino.usdz` 파일을 불러오는 방식으로 교체한 기록입니다. 기준 커밋: `6326d07`(Tune domino mass to a fixed 0.7kg) — 이 커밋 상태가 "이전" 코드입니다.

## 이전 코드 (절차적 mesh)

```swift
private let dominoSize = SIMD3<Float>(0.08, 0.2, 0.04)
```

```swift
// 도미노 엔티티 조립 담당: mesh(모양) + 재질(겉모습) + 충돌 shape + 물리 바디를 순서대로 붙임
private func makeDominoEntity() -> ModelEntity {
    // generateBox(width:height:depth:)는 너비=로컬 X축, 높이=로컬 Y축, 깊이=로컬 Z축인
    // 직육면체를 원점 중심으로 만듦. 즉 이 mesh를 회전 없이 그대로 쓰면 "높이" 방향이
    // 로컬 Y축을 향함 — place(_:at:in:)에서 이 점을 활용해 별도 회전 없이 세움
    let mesh = MeshResource.generateBox(width: dominoSize.x, height: dominoSize.y, depth: dominoSize.z)

    // PhysicallyBasedMaterial: metallic은 0으로 두어 환경 반사 없이도 자연스러운 광택이 나오게 함
    var material = PhysicallyBasedMaterial()
    material.baseColor = .init(tint: .red)
    material.roughness = .init(floatLiteral: 0.4)
    material.metallic = .init(floatLiteral: 0.0)

    let domino = ModelEntity(mesh: mesh, materials: [material])

    // 충돌 shape: 도미노끼리 부딪히려면 반드시 필요함 (엔티티 자체의 속성이라 여기서 붙임)
    domino.generateCollisionShapes(recursive: true)
    // PhysicsBodyComponent(.dynamic): 중력을 받아 물리 바닥 위에 서고, 나중에 임펄스(힘)를 받으면
    // 실제로 넘어지고, 다른 도미노와 부딪히면 밀어내는 등 물리 시뮬레이션에 참여함.
    // massProperties: 자동 계산(.default) 대신 직접 질량(kg)을 지정해 튜닝함
    domino.components.set(PhysicsBodyComponent(massProperties: .init(mass: dominoMass), material: .default, mode: .dynamic))

    return domino
}

// 배치 담당: raycast로 얻은 위치/방향에 도미노를 실제로 씬에 등록함
private func place(_ domino: ModelEntity, at transform: simd_float4x4, in arView: ARView) {
    let anchorEntity = AnchorEntity(world: transform)

    // mesh가 원점을 중심으로 만들어져 있어서, 회전 없이 그대로 놓으면 도미노의 절반이
    // 바닥 아래로 파묻힘. 높이의 절반만큼 로컬 Y축으로 띄워서 바닥 위에 정확히 서게 함
    domino.position = SIMD3<Float>(0, dominoSize.y / 2, 0)

    anchorEntity.addChild(domino)
    arView.scene.addAnchor(anchorEntity)
}
```

## 이후 코드 (USDZ 모델)

```swift
// 도미노 엔티티 조립 담당: USDZ 모델(모양+재질) + 충돌 shape + 물리 바디를 순서대로 붙임
private func makeDominoEntity() -> ModelEntity {
    // domino.usdz 안에 mesh와 나무 재질이 이미 담겨 있어서, 절차적으로 만들 필요가 없음.
    // 회전 없이 그대로 쓰면 세워진 상태가 되도록 Blender에서 로컬 Y축 = 높이로 모델링해둠
    let domino = try! ModelEntity.loadModel(named: "domino")

    // 충돌 shape: 도미노끼리 부딪히려면 반드시 필요함 (엔티티 자체의 속성이라 여기서 붙임)
    domino.generateCollisionShapes(recursive: true)
    // PhysicsBodyComponent(.dynamic): 중력을 받아 물리 바닥 위에 서고, 나중에 임펄스(힘)를 받으면
    // 실제로 넘어지고, 다른 도미노와 부딪히면 밀어내는 등 물리 시뮬레이션에 참여함.
    // massProperties: 자동 계산(.default) 대신 직접 질량(kg)을 지정해 튜닝함
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
```

`dominoSize` 상수(`SIMD3<Float>(0.08, 0.2, 0.04)`)는 더 이상 어디에서도 쓰이지 않아 함께 삭제됨.

## 변경 요약

| 항목 | 이전 | 이후 |
|---|---|---|
| 모양 생성 | `MeshResource.generateBox(...)`로 코드에서 직접 그림 | `ModelEntity.loadModel(named: "domino")`로 USDZ 파일에서 불러옴 |
| 재질 | `PhysicallyBasedMaterial`을 코드로 직접 구성(빨간 단색) | USDZ 파일에 이미 포함된 나무 재질을 그대로 사용 |
| 배치 오프셋 | `dominoSize.y`라는 코드 상수 기준 | `domino.visualBounds(relativeTo: nil)`로 실제 로드된 모델을 측정해 계산 |
| 충돌/물리 바디 | 동일 | 변경 없음 |
