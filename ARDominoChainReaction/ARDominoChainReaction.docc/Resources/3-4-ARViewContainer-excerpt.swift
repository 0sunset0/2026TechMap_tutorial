struct ARViewContainer: UIViewRepresentable {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let configuration = makeSessionConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = context.coordinator

        configureDebugOptions(for: arView)
        setupTapGesture(on: arView, coordinator: context.coordinator)
        context.coordinator.arView = arView

        return arView
    }

    private func setupTapGesture(on arView: ARView, coordinator: ARCoordinator) {
        let tapGesture = UITapGestureRecognizer(
            target: coordinator,
            action: #selector(ARCoordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
    }
}
