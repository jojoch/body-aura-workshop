//
//  HumanPoseColor.swift
//  BodyAura
//
//  Created by Veronika Zelinkova on 17.06.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Foundation

enum HumanPoseColor {
    case blue
    case red
    case white
    case yellow
}

extension HumanPoseColor {
    var vector: SIMD4<Float> {
        switch self {
        case .blue:
            return .init(0, 0, 1, 1)
        case .red:
            return .init(1, 0, 0, 1)
        case .white:
            return .init(1, 1, 1, 1)
        case .yellow:
            return .init(1, 1, 0, 1)
        }
    }
}
