//
//  AppDelegate.swift
//  STRV Project template
//
//  Created by Jan Kaltoun on 29/11/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, AppCoordinatorContaining {
    var window: UIWindow?

    // swiftlint:disable:next implicitly_unwrapped_optional
    var coordinator: AppCoordinating!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coordinator = AppCoordinator()
        coordinator.start()
        return true
    }
}

// MARK: UISceneSession Lifecycle

extension AppDelegate {
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        guard let name = Configuration.default.sceneManifest?.configurations.applicationScenes.first?.name else {
            fatalError("No scene configuration")
        }

        return UISceneConfiguration(name: name, sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        for session in sceneSessions {
            coordinator.didDestroy(session: session)
        }
    }
}
