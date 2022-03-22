//
//  DetectPoseServicing.swift
//  BodyAura
//
//  Created by Veronika Zelinkova on 17.06.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Foundation
import Vision
import Combine

protocol DetectPoseServicing {
    func detectPose(in buffer: CVPixelBuffer) -> Future<HumanPose, DetectPoseError>
}
