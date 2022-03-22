//
//  DetectPoseService.swift
//  BodyAura
//
//  Created by Veronika Zelinkova on 17.06.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Foundation
import Combine
import Vision

class DetectPoseService {
    // MARK: - Private Properties
    
    private let queue = DispatchQueue.global(qos: .userInitiated)
}

// MARK: - DetectPoseServicing

extension DetectPoseService: DetectPoseServicing {
    func detectPose(in buffer: CVPixelBuffer) -> Future<HumanPose, DetectPoseError> {
        return Future { promise in
            // TODO: 4 - Implementation
            promise(.success(.notDetected))
        }
    }
}
