import UIKit
import RealityKit
import ARKit
import simd

// ARCoordinator: ARViewContainer(UIViewRepresentable)가 UIKit 이벤트(델리게이트 콜백, 제스처 등)를
// 받기 위한 중개자
class ARCoordinator: NSObject, ARSessionDelegate {
    weak var arView: ARView?
    let status: ARStatusModel

    init(status: ARStatusModel) {
        self.status = status
    }
}
