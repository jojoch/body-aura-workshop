//
//  UISegmentControl+CustomPublisher.swift
//  STRV Project template
//
//  Created by Jaroslav Janda on 10.03.2021.
//  Copyright © 2021 EndFA, LLC. All rights reserved.
//

import Combine
import UIKit

public extension UISegmentedControl {
    var valueChangedPublisher: AnyPublisher<UISegmentedControl, Never> {
        EventPublisher(control: self, event: .valueChanged)
            .share()
            .eraseToAnyPublisher()
    }

    var selectedSegmentIndexPublisher: AnyPublisher<Int, Never> {
        valueChangedPublisher
            .map(\.selectedSegmentIndex)
            .share()
            .eraseToAnyPublisher()
    }
}
