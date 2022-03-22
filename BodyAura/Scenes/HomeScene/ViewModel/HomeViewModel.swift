//
//  HomeViewModel.swift
//  BodyAura
//
//  Created by Jan on 30/07/2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import Combine
import CombineExt
import UIKit

class HomeViewModel: ViewModelType {
    struct Input {
        let capturedImage: AnyPublisher<CVPixelBuffer, Never>
    }

    struct Output {
        let auraColor: AnyPublisher<HumanPoseColor, Never>
    }
    
    // MARK: - Private Properties
    
    private let detectPoseService: DetectPoseServicing
    
    // MARK: - Initialization
    
    init(detectPoseService: DetectPoseServicing) {
        self.detectPoseService = detectPoseService
    }
    
    // MARK: Public Methods

    func transform(input: Input) -> Output {
        let auraColor = input.capturedImage
            .flatMap { [detectPoseService] capturedImage in
                detectPoseService.detectPose(in: capturedImage)
                    .mapError { $0 as Error }
                    .materialize()
            }
            .eraseToAnyPublisher()
    
        return Output(
            auraColor: auraColor.values().map { $0.color }.eraseToAnyPublisher()
        )
    }
}
