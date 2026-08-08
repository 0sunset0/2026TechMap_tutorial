import SwiftUI

struct ContentView: View {
    // @StateObject: 이 뷰가 ARStatusModel을 "처음 생성"하고 소유함
    @StateObject private var status = ARStatusModel()

    var body: some View {
        // ZStack(alignment: .top): AR 카메라 화면 위에 상태 배너를 겹쳐서(오버레이) 보여줌
        ZStack(alignment: .top) {
            ARViewContainer(status: status)
                .edgesIgnoringSafeArea(.all)

            Text(status.statusText)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.black.opacity(0.6))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(.top, 60)
        }
    }
}
