//
//  HomeCoordinatorEventHandling.swift
//  BodyAura
//
//  Created by Jan on 07/08/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Foundation

enum HomeCoordinatorEvent {}

protocol HomeCoordinatorEventHandling {
    func handle(event: HomeCoordinatorEvent)
}
