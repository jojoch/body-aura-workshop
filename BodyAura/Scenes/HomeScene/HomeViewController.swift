//
//  HomeViewController.swift
//  BodyAura
//
//  Created by Jan on 30/07/2019.
//  Copyright © 2019 STRV. All rights reserved.
//
import ARKit
import Combine
import MetalKit
import UIKit

class HomeViewController: UIViewController, ViewModelContaining {
    // MARK: Public Properties
    
    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var coordinator: HomeViewEventHandling!
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: HomeViewModel!

    // MARK: Private Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let session = ARSession()
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var renderer: Renderer!
    private let capturedImage = PassthroughSubject<CVPixelBuffer, Never>()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupARConfiguration()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        session.pause()
    }
}

// MARK: Private Methods

private extension HomeViewController {
    func setup() {
        setupMetal()
        bindToViewModel()
    }

    func setupMetal() {
        guard let mtkView = view as? MTKView,
              let device = MTLCreateSystemDefaultDevice()
        else {
            fatalError("Metal is not supported on this device")
        }

        mtkView.device = device
        mtkView.backgroundColor = .clear
        mtkView.delegate = self
        
        session.delegate = self

        renderer = Renderer(session: session, metalDevice: device, renderDestination: mtkView)
        renderer.drawRectResized(size: view.bounds.size)
    }

    func bindToViewModel() {
        let output = viewModel.transform(
            input: .init(
                capturedImage: capturedImage.eraseToAnyPublisher()
            )
        )
        
        output.auraColor
            .sink { [weak self] color in
                // TODO: 4 - Uncomment this
                // self?.renderer.auraColor = color.vector
            }
            .store(in: &cancellables)
    }

    func setupARConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .personSegmentation
        session.run(configuration)
    }
}

// MARK: - MTKViewDelegate

extension HomeViewController: MTKViewDelegate {
    func mtkView(_: MTKView, drawableSizeWillChange size: CGSize) {
        renderer.drawRectResized(size: size)
    }

    func draw(in _: MTKView) {
        renderer.update()
    }
}

// MARK: - ARSessionDelegate

extension HomeViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        capturedImage.send(frame.capturedImage)
    }
}

extension MTKView: RenderDestinationProvider {}
