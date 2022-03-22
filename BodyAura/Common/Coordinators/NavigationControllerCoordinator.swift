//
//  NavigationControllerCoordinator.swift
//  BodyAura
//
//  Created by Jan Kaltoun on 01/12/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

public protocol NavigationControllerCoordinator: ViewControllerCoordinator {
    var navigationController: UINavigationController { get }
}

public extension NavigationControllerCoordinator {
    var rootViewController: UIViewController {
        navigationController
    }
}
