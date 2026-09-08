struct ARViewContainer: UIViewRepresentable {
    // 기존 프로퍼티와 다른 메서드는 생략했습니다. 작성한 코드는 유지하세요.

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

}
