//
//  SceneCoordinating.swift
//  BodyAura
//
//  Created by Jan on 01/05/2020.
//  Copyright © 2020 STRV. All rights reserved.
//

import Swinject
import UIKit

public protocol SceneCoordinating: Coordinator {
    init(window: UIWindow, assembler: Assembler)
}
