//
//  UIButton+CustomPublisher.swift
//  STRV Project template
//
//  Created by Marek Slávik on 11.02.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Combine
import UIKit

public extension UIButton {
    var tapPublisher: AnyPublisher<UIButton, Never> {
        EventPublisher(control: self, event: .touchUpInside)
            .share()
            .eraseToAnyPublisher()
    }
}
