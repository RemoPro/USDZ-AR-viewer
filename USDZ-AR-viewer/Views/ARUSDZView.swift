import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARUSDZView: UIViewRepresentable {
    let usdzURL: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.backgroundColor = .black

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)

        ModelEntity.loadModelAsync(contentsOf: usdzURL)
            .sink(receiveCompletion: { _ in }, receiveValue: { entity in
                let anchor = AnchorEntity(world: .zero)
                anchor.addChild(entity)
                arView.scene.addAnchor(anchor)
            })
            .store(in: &context.coordinator.cancellables)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) { }

    class Coordinator {
        var cancellables = Set<AnyCancellable>()
    }
}