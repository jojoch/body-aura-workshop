//
//  UIWindowSceneDelegate+Convenience.swift
//  BodyAura
//
//  Created by Jan on 01/05/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import UIKit

public extension UIWindowSceneDelegate {
    var session: UISceneSession {
        guard let window = self.window, let session = window?.windowScene?.session else {
            fatalError("Scene delegate not connected to any session \(self)")
        }

        return session
    }
}
