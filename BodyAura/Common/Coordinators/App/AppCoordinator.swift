//
//  AppCoordinator.swift
//  STRV Project template
//
//  Created by Jan Kaltoun on 30/11/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Swinject
import UIKit

final class AppCoordinator {
    var childCoordinators = [Coordinator]()

    private(set) lazy var activeSessions: [ActiveSceneSession] = []

    let assembler = Assembler()
}

// MARK: - AppCoordinating

extension AppCoordinator: AppCoordinating {
    func start() {
        assembleDependencyInjectionContainer()
    }
}

// MARK: - Assembly

// Extension is internal to be accessible from test target
extension AppCoordinator {
    func assembleDependencyInjectionContainer() {
        assembler.apply(
            assemblies: [ViewModelAssembly(), ServiceAssembly()]
        )
    }
}

// MARK: Scenes management
extension AppCoordinator {
    func didLaunchScene<Coordinator: SceneCoordinating>(for session: UISceneSession, window: UIWindow) -> Coordinator {
        let coordinator: Coordinator = makeSceneCoordinator(with: window)

        activeSessions.append((session: session, coordinatorId: ObjectIdentifier(coordinator)))
        childCoordinators.append(coordinator)

        return coordinator
    }

    func didDisconnectScene(for session: UISceneSession) {
        removeSceneCoordinator(for: session)
    }

    func didDestroy(session: UISceneSession) {
        removeSceneCoordinator(for: session)

        if let index = activeSessions.firstIndex(where: { $0.session == session }) {
            activeSessions.remove(at: index)
        }
    }
}

// MARK: Coordinators management
private extension AppCoordinator {
    func makeSceneCoordinator<Coordinator: SceneCoordinating>(with window: UIWindow) -> Coordinator {
        let coordinator = Coordinator(window: window, assembler: assembler)

        return coordinator
    }

    func removeSceneCoordinator(for session: UISceneSession) {
        guard let index = activeSessions.firstIndex(where: { $0.session == session }) else {
            return
        }

        let coordinatorId = activeSessions[index].coordinatorId

        // Remove coordinator from child coordinators
        if let index = childCoordinators.firstIndex(where: { ObjectIdentifier($0) == coordinatorId }) {
            childCoordinators.remove(at: index)
        }

        // Unregister the coordinator from the active session
        activeSessions[index].coordinatorId = nil
    }
}
