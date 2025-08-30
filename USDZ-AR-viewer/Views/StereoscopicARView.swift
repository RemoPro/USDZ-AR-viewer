//
//  StereoscopicARView.swift
//  USDZ-AR-viewer
//
//  Created by Remo on 30.08.2025.
//


//import SwiftUI
//import RealityKit
//import ARKit
//import Combine
//
//struct StereoscopicARView: UIViewRepresentable {
//    let usdzURL: URL
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    func makeUIView(context: Context) -> UIView {
//        let container = UIView(frame: CGRect(x: 0, y: 0, width: 3840, height: 1080))
//        container.backgroundColor = .black
//
//        let leftARView = ARView(frame: CGRect(x: 0, y: 0, width: 1920, height: 1080))
//        let rightARView = ARView(frame: CGRect(x: 1920, y: 0, width: 1920, height: 1080))
//        leftARView.backgroundColor = .black
//        rightARView.backgroundColor = .black
//
//        container.addSubview(leftARView)
//        container.addSubview(rightARView)
//
//        ModelEntity.loadModelAsync(contentsOf: usdzURL)
//            .sink(receiveCompletion: { _ in }, receiveValue: { entity in
//                let leftAnchor = AnchorEntity(world: .zero)
//                let rightAnchor = AnchorEntity(world: .zero)
//
//                leftAnchor.addChild(entity.clone(recursive: true))
//                rightAnchor.addChild(entity.clone(recursive: true))
//                leftARView.scene.addAnchor(leftAnchor)
//                rightARView.scene.addAnchor(rightAnchor)
//
//                // Stereo camera offset (IPD ~ 6.5cm)
//                let ipd: Float = 0.065
//
//                // Camera anchor for left view
//                let leftCameraAnchor = AnchorEntity(.camera)
//                leftCameraAnchor.transform.translation.x -= ipd / 2
//                leftARView.scene.addAnchor(leftCameraAnchor)
//
//                // Camera anchor for right view
//                let rightCameraAnchor = AnchorEntity(.camera)
//                rightCameraAnchor.transform.translation.x += ipd / 2
//                rightARView.scene.addAnchor(rightCameraAnchor)
//            })
//            .store(in: &context.coordinator.cancellables)
//
//        return container
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//
//    class Coordinator {
//        var cancellables = Set<AnyCancellable>()
//    }
//}

import SwiftUI
import RealityKit
import ARKit

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

        Task {
            do {
                let entity = try await ModelEntity(contentsOf: usdzURL)

                let leftAnchor = AnchorEntity(world: .zero)
                let rightAnchor = AnchorEntity(world: .zero)

                leftAnchor.addChild(entity.clone(recursive: true))
                rightAnchor.addChild(entity.clone(recursive: true))
                leftARView.scene.addAnchor(leftAnchor)
                rightARView.scene.addAnchor(rightAnchor)

                // Stereo camera offset (IPD ~ 6.5cm)
                let ipd: Float = 0.065

                let leftCameraAnchor = AnchorEntity(.camera)
                leftCameraAnchor.transform.translation.x -= ipd / 2
                leftARView.scene.addAnchor(leftCameraAnchor)

                let rightCameraAnchor = AnchorEntity(.camera)
                rightCameraAnchor.transform.translation.x += ipd / 2
                rightARView.scene.addAnchor(rightCameraAnchor)
            } catch {
                print("Error loading USDZ model: \(error)")
            }
        }

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator {}
}
