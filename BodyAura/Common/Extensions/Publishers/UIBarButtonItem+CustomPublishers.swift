//
//  UIBarButtonItem+CustomPublishers.swift
//  STRV Project template
//
//  Created by Jan Remes on 17.02.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Combine
import UIKit

public extension UIBarButtonItem {
    /// A publisher which emits whenever this UIBarButtonItem is tapped.
    var tapPublisher: AnyPublisher<UIBarButtonItem, Never> {
        Publishers.ControlTarget(control: self) { target, action in
            self.target = target
            self.action = action
        } removeTargetAction: { _, _ in
            self.target = nil
            self.action = nil
        }
        .share()
        .eraseToAnyPublisher()
    }
}
