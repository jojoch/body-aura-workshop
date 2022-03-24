//
//  HomeCoordinator.swift
//  BodyAura
//
//  Created by Jan on 07/08/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Swinject
import UIKit

final class HomeCoordinator {
    var parent: HomeCoordinatorEventHandling?
    var childCoordinators = [Coordinator]()

    let assembler: Assembler

    lazy var rootViewController: UIViewController = makeHomeViewController()

    init(assembler: Assembler, parent: HomeCoordinatorEventHandling?) {
        self.assembler = assembler
        self.parent = parent
    }
}

// MARK: - View Controller Factory
extension HomeCoordinator {
    func makeHomeViewController() -> HomeViewController {
        let viewController: HomeViewController = HomeViewController.storyboardInit(viewModel: resolve(HomeViewModel.self))
        
        viewController.coordinator = self

        return viewController
    }
}

// MARK: - ViewControllerCoordinator
extension HomeCoordinator: ViewControllerCoordinator {
    func start() {}
}

// MARK: - HomeViewEventHandling
extension HomeCoordinator: HomeViewEventHandling {
    func handle(event _: HomeViewEvent) {}
}
