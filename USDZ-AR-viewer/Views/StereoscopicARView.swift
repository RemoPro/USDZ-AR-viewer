import SwiftUI
import RealityKit
import ARKit
import Combine

struct StereoscopicARView: UIViewRepresentable {
    let usdzURL: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 3840, height: 1080))
        container.backgroundColor = .black

        let leftARView = ARView(frame: CGRect(x: 0, y: 0, width: 1920, height: 1080))
        let rightARView = ARView(frame: CGRect(x: 1920, y: 0, width: 1920, height: 1080))
        leftARView.backgroundColor = .black
        rightARView.backgroundColor = .black

        container.addSubview(leftARView)
        container.addSubview(rightARView)

        ModelEntity.loadModelAsync(contentsOf: usdzURL)
            .sink(receiveCompletion: { _ in }, receiveValue: { entity in
                let leftAnchor = AnchorEntity(world: .zero)
                let rightAnchor = AnchorEntity(world: .zero)

                leftAnchor.addChild(entity.clone(recursive: true))
                rightAnchor.addChild(entity.clone(recursive: true))
                leftARView.scene.addAnchor(leftAnchor)
                rightARView.scene.addAnchor(rightAnchor)

                // Stereo camera offset (IPD ~ 6.5cm)
                let ipd: Float = 0.065
                leftARView.cameraTransform.translation.x -= ipd / 2
                rightARView.cameraTransform.translation.x += ipd / 2
            })
            .store(in: &context.coordinator.cancellables)

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator {
        var cancellables = Set<AnyCancellable>()
    }
}