import SwiftUI
import RealityKit
import ARKit

// UIViewRepresentable: UIKit 뷰(ARView)를 SwiftUI 안에 끼워 넣을 수 있게 해주는 어댑터 프로토콜
struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var status: ARStatusModel
}
