//
//  StoryboardInit.swift
//  STRV Project template
//
//  Created by Jan Kaltoun on 30/11/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

// MARK: - View Controller initialization

public protocol StoryboardInit {}

// MARK: - View Controller initialization without a ViewModel

public extension StoryboardInit where Self: UIViewController {
    static func storyboardInit() -> Self {
        // swiftlint:disable force_cast
        UIStoryboard(
            name: String(describing: self),
            bundle: Bundle(for: self)
        ).instantiateInitialViewController() as! Self
        // swiftlint:enable force_cast
    }
}

// MARK: - View Controller initialization with a ViewModel

public extension StoryboardInit where Self: UIViewController & ViewModelContaining {
    static func storyboardInit(viewModel: ViewModel) -> Self {
        var viewController = storyboardInit()

        viewController.viewModel = viewModel

        return viewController
    }
}
