//
//  HumanPose.swift
//  BodyAura
//
//  Created by Veronika Zelinkova on 17.06.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Foundation
import CoreGraphics

enum HumanPose {
    case leftHandUp
    case rightHandUp
    case bothHandsUp
    case notDetected
}

extension HumanPose {
    init(nose: CGPoint, leftWrist: CGPoint, rightWrist: CGPoint) {
        let leftHandUp = leftWrist.x < nose.x
        let rightHandUp = rightWrist.x < nose.x
        
        if leftHandUp && rightHandUp {
            self = .bothHandsUp
        } else if leftHandUp && !rightHandUp {
            self = .leftHandUp
        } else if !leftHandUp && rightHandUp {
            self = .rightHandUp
        } else {
            self = .notDetected
        }
    }
    
    var color: HumanPoseColor {
        switch self {
        case .leftHandUp:
            return .blue
        case .rightHandUp:
            return .red
        case .bothHandsUp:
            return .yellow
        case .notDetected:
            return .white
        }
    }
}
