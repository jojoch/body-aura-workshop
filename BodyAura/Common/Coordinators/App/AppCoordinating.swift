//
//  AppCoordinating.swift
//  STRV Project template
//
//  Created by Jan Kaltoun on 24/01/2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

public protocol AppCoordinating: Coordinator {
    func didLaunchScene<Coordinator: SceneCoordinating>(for session: UISceneSession, window: UIWindow) -> Coordinator

    func didDisconnectScene(for session: UISceneSession)

    func didDestroy(session: UISceneSession)
}
