//
//  ParentCoordinatorContaining.swift
//  BodyAura
//
//  Created by Jan on 07/08/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Foundation

public protocol ParentCoordinatorContaining: AnyObject {
    associatedtype ParentCoordinator

    var parent: ParentCoordinator? { get set }
}
