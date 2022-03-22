//
//  HomeViewEventHandling.swift
//  BodyAura
//
//  Created by Jan on 07/08/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Foundation

enum HomeViewEvent {}

protocol HomeViewEventHandling: AnyObject {
    func handle(event: HomeViewEvent)
}
