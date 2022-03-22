//
//  ViewModelAssembly.swift
//  BodyAura
//
//  Created by Jan Kaltoun on 01/12/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Swinject

// swiftlint:disable force_unwrapping
final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewModel.self) { resolver in
            HomeViewModel(
                detectPoseService: resolver.resolve(DetectPoseServicing.self)!
            )
        }.inObjectScope(.graph)
    }
}
