//
//  SceneDelegate.swift
//  BodyAura
//
//  Created by Jan on 01/05/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    // swiftlint:disable:next implicitly_unwrapped_optional
    weak var coordinator: InitialSceneCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        setupInitialScene(with: windowScene, session: session)
    }

    func sceneDidDisconnect(_: UIScene) {
        appCoordinator.didDisconnectScene(for: session)
    }
}

// MARK: - Setup
private extension SceneDelegate {
    func setupInitialScene(with windowScene: UIWindowScene, session: UISceneSession) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        coordinator = appCoordinator.didLaunchScene(for: session, window: window)

        coordinator.start()
    }
}
