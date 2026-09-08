class ARCoordinator: NSObject, ARSessionDelegate {
    // 관련 없는 기존 코드는 생략했습니다. 작성한 코드는 그대로 유지하세요.

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        status.statusText = "탭을 감지했어요"
    }
}
