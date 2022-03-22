//
//  Coordinator.swift
//  BodyAura
//
//  Created by Jan Kaltoun on 30/11/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Swinject

public protocol Coordinator: AnyObject {
    var assembler: Assembler { get }
    var childCoordinators: [Coordinator] { get set }

    func start()
}

// MARK: - Dependency Injection

public extension Coordinator {
    func resolve<Service>(_ serviceType: Service.Type, synchronize: Bool = false) -> Service {
        guard synchronize else {
            // swiftlint:disable:next force_unwrapping
            return assembler.resolver.resolve(serviceType)!
        }

        let container = assembler.resolver as? Container

        // swiftlint:disable:next force_unwrapping
        return container!.synchronize().resolve(serviceType)!
    }

    func resolve<Service: ViewModelContaining>(_ serviceType: Service.Type, viewModel: Service.ViewModel, synchronize: Bool = false) -> Service? {
        var instance = resolve(serviceType, synchronize: synchronize)

        instance.viewModel = viewModel

        return instance
    }
}
