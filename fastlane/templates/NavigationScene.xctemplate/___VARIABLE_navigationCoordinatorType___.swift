// ___FILEHEADER___

import Swinject
import UIKit

final class ___FILEBASENAMEASIDENTIFIER___ {
    var childCoordinators = [Coordinator]()
    let assembler: Assembler

    let navigationController: UINavigationController

    init(navigationController: UINavigationController, assembler: Assembler) {
        self.navigationController = navigationController
        self.assembler = assembler
    }
}

// MARK: - ___FILEBASENAMEASIDENTIFIER___ing

extension ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___ing {
    func start() {
        navigationController.pushViewController(
            makeRootViewController(),
            animated: false
        )
    }
}

// MARK: - Factories

// Extension is internal to be accessible from test target
internal extension ___FILEBASENAMEASIDENTIFIER___ {
    func makeRootViewController() -> UIViewController {
        // DO NOT FORGET TO ADD VIEW MODEL TO `ViewModelAssembly.swift`
//        let viewController = R.storyboard.specificViewController.instantiateInitialViewController(
//            viewModel: resolve(SpecificViewModeling.self)
//        )
//        viewController.coordinator = self

        return UIViewController()
    }
}
