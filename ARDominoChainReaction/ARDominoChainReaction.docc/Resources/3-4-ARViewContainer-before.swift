struct ARViewContainer: UIViewRepresentable {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let configuration = makeSessionConfiguration()
        arView.session.run(configuration)
        arView.session.delegate = context.coordinator

        configureDebugOptions(for: arView)
        context.coordinator.arView = arView

        return arView
    }
}
