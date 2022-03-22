//
//  TabBarControllerCoordinator.swift
//  BodyAura
//
//  Created by Jan Kaltoun on 01/12/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

public protocol TabBarControllerCoordinator: ViewControllerCoordinator {
    var tabBarController: UITabBarController { get }
}

public extension TabBarControllerCoordinator {
    var rootViewController: UIViewController {
        tabBarController
    }
}
