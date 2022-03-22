//
//  UIRefreshControll+CustomPublisher.swift
//  STRV Project template
//
//  Created by Jaroslav Janda on 10.03.2021.
//  Copyright © 2021 EndFA, LLC. All rights reserved.
//

import Combine
import UIKit

public extension UIRefreshControl {
    var primaryActionPublisher: AnyPublisher<UIRefreshControl, Never> {
        EventPublisher(control: self, event: .primaryActionTriggered)
            .share()
            .eraseToAnyPublisher()
    }

    var isRefreshingPublisher: AnyPublisher<Bool, Never> {
        primaryActionPublisher
            .map(\.isRefreshing)
            .share()
            .eraseToAnyPublisher()
    }
}
