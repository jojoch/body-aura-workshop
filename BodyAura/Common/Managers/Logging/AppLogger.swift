//
//  AppLogger.swift
//  STRV Project template
//
//  Created by Jan Kaltoun on 01/12/2018.
//  Copyright © 2018 STRV. All rights reserved.
//

import Foundation
import XCGLogger

public final class AppLogger {
    // MARK: - Singleton

    // For logging we really want a singleton for convenience
    public static let shared: XCGLogger = {
        let logger = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
        let appLogger = AppLogger()

        appLogger.setupXCGLogger(logger: logger)

        return logger
    }()

    // MARK: - Setup

    func setupXCGLogger(logger: XCGLogger) {
        logger.setup(
            level: .debug,
            showThreadName: true,
            showLevel: true,
            showFileNames: true,
            showLineNumbers: true,
            fileLevel: .debug
        )

        setupXCGLoggerSystemDestination(logger: logger)
        setupXCGLoggerFileDestination(logger: logger)

        // Useful app launch logging
        logger.logAppDetails()
    }

    private func setupXCGLoggerSystemDestination(logger: XCGLogger) {
        // Create an emoji log formatter for system log destination
        let emojiLogFormatter = PrePostFixLogFormatter()
        emojiLogFormatter.apply(prefix: "🗯🗯🗯", to: .verbose)
        emojiLogFormatter.apply(prefix: "🔹🔹🔹", to: .debug)
        emojiLogFormatter.apply(prefix: "💡💡💡", to: .info)
        emojiLogFormatter.apply(prefix: "⚠️⚠️⚠️", to: .warning)
        emojiLogFormatter.apply(prefix: "‼️‼️‼️", to: .error)
        emojiLogFormatter.apply(prefix: "💣💣💣", to: .severe)

        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")

        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = false
        systemDestination.showThreadName = false
        systemDestination.showLevel = false
        systemDestination.showFileName = false
        systemDestination.showLineNumber = false
        systemDestination.showDate = true
        systemDestination.formatters = [emojiLogFormatter]

        // Activate the log destination
        logger.add(destination: systemDestination)
    }

    private func setupXCGLoggerFileDestination(logger: XCGLogger) {
        // Create a coloured log formatter for file log destination
        let ansiColorLogFormatter = ANSIColorLogFormatter()
        ansiColorLogFormatter.colorize(level: .verbose, with: .colorIndex(number: 244), options: [.faint])
        ansiColorLogFormatter.colorize(level: .debug, with: .black)
        ansiColorLogFormatter.colorize(level: .info, with: .blue)
        ansiColorLogFormatter.colorize(level: .warning, with: .red, options: [.faint])
        ansiColorLogFormatter.colorize(level: .error, with: .red, options: [.bold])
        ansiColorLogFormatter.colorize(level: .severe, with: .white, on: .red)

        // Create a file log destination
        let temporaryFileDestination = FileDestination(
            writeToFile: "/tmp/app.log",
            identifier: "advancedLogger.temporaryFileDestination"
        )

        let documentsDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        ).first ?? ""

        let documentsFileDestination = FileDestination(
            writeToFile: "\(documentsDirectory)/app.log",
            identifier: "advancedLogger.documentsFileDestination"
        )

        // Activate log destinations
        [temporaryFileDestination, documentsFileDestination].forEach { fileDestination in
            fileDestination.outputLevel = .verbose
            fileDestination.showLogIdentifier = false
            fileDestination.showFunctionName = true
            fileDestination.showThreadName = true
            fileDestination.showLevel = true
            fileDestination.showFileName = true
            fileDestination.showLineNumber = true
            fileDestination.showDate = true
            fileDestination.formatters = [ansiColorLogFormatter]

            // Process this destination in the background
            fileDestination.logQueue = XCGLogger.logQueue

            // Add the destination to the logger
            logger.add(destination: fileDestination)
        }
    }
}
