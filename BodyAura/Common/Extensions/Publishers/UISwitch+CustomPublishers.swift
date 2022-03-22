//
//  UISwitch+CustomPublisher.swift
//  STRV Project template
//
//  Created by Jaroslav Janda on 10.03.2021.
//  Copyright © 2021 EndFA, LLC. All rights reserved.
//

import Combine
import UIKit

public extension UISwitch {
    var valueChangedPublisher: AnyPublisher<UISwitch, Never> {
        EventPublisher(control: self, event: .valueChanged)
            .share()
            .eraseToAnyPublisher()
    }

    var isOnPublisher: AnyPublisher<Bool, Never> {
        valueChangedPublisher
            .map(\.isOn)
            .share()
            .eraseToAnyPublisher()
    }
}
