//
//  main.swift
//  STRV Project template
//
//  Created by Jiri Ostatnicky on 13/02/2019.
//  Copyright © 2019 STRV. All rights reserved.
//

import UIKit

private func delegateClassName() -> AnyClass {
    NSClassFromString("TestAppDelegate") ?? AppDelegate.self
}

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(delegateClassName()))
