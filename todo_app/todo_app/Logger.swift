//
//  Logger.swift
//  todo_app
//
//  Created by Максим Кузнецов on 21.06.2024.
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier ?? "default"
    static let services = Logger(subsystem: subsystem, category: "services")
}
