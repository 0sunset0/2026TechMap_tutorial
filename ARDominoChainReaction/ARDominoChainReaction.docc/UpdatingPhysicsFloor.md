# 심화: 감지된 평면에 맞춰 물리 바닥 갱신하기

@Metadata {
    @TechnologyRoot
}

스캔이 진행되면 ARKit이 감지한 평면의 위치와 크기가 달라질 수 있습니다.

튜토리얼에서는 물리 바닥을 처음 감지한 크기로 만듭니다. 이후 감지 범위가 넓어져도
물리 바닥을 갱신하지 않으면, 새로 감지한 영역에는 도미노를 받쳐줄 충돌 범위가 없습니다.
이곳에 배치한 도미노는 바닥 아래로 떨어질 수 있습니다.

저장소의 완성된 `ARCoordinator.swift`에서는 `physicsFloors`에 평면의 `identifier`와
물리 바닥 엔티티를 연결해 저장합니다. `session(_:didUpdate:)`에서 해당 엔티티를 찾아
평면의 최신 위치와 크기에 맞춰 갱신합니다.

직접 확장해보고 싶다면 완성 코드의 `session(_:didUpdate:)`와 `addPhysicsFloor(for:)`를 함께 살펴보세요.
