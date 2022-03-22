//
//  UISceneDelegate+AppCoordinator.swift
//  BodyAura
//
//  Created by Jan on 01/05/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import UIKit

public extension UISceneDelegate {
    var appCoordinator: AppCoordinating {
        guard let delegate = UIApplication.shared.delegate as? AppCoordinatorContaining else {
            fatalError("Application delegate doesn't implement `AppCoordinatorDelegating` protocol")
        }

        return delegate.coordinator
    }
}
