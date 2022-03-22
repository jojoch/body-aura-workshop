//
//  UITextField+CustomPublisher.swift
//  STRV Project template
//
//  Created by Jan Remes on 17.02.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Combine
import UIKit

public extension UITextField {
    var valueChangedPublisher: AnyPublisher<UITextField, Never> {
        EventPublisher(control: self, event: [.allEditingEvents, .valueChanged])
            .share()
            .eraseToAnyPublisher()
    }

    var textPublisher: AnyPublisher<String?, Never> {
        valueChangedPublisher
            .map(\.text)
            .share()
            .eraseToAnyPublisher()
    }

    var didReturnPublisher: AnyPublisher<UITextField, Never> {
        EventPublisher(control: self, event: .editingDidEndOnExit)
            .share()
            .eraseToAnyPublisher()
    }
}
