//
//  ServiceAssembly.swift
//  BodyAura
//
//  Created by Veronika Zelinkova on 17.06.2021.
//  Copyright © 2021 STRV. All rights reserved.
//


import Swinject

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(DetectPoseServicing.self) { _ in
            DetectPoseService()
        }.inObjectScope(.container)
    }
}
