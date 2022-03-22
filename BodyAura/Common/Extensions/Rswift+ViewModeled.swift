//
//  Rswift+ViewModelContaining.swift
//  BodyAura
//
//  Created by Jan Kaltoun on 30/11/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Rswift

// MARK: - Initial View Controller instantiation using ViewModel

public extension StoryboardResourceWithInitialControllerType where Self.InitialController: ViewModelContaining {
    func instantiateInitialViewController(viewModel: Self.InitialController.ViewModel) -> Self.InitialController {
        var viewController: Self.InitialController? = instantiateInitialViewController()

        viewController?.viewModel = viewModel

        // swiftlint:disable:next force_unwrapping
        return viewController!
    }
}
