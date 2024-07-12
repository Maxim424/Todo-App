//
//  TodoItem+CSV.swift
//  todo_app
//
//  Created by Максим Кузнецов on 21.06.2024.
//

import Foundation
import CocoaLumberjackSwift

extension TodoItem {
    public static func parse(csv: String) -> TodoItem? {
        let components = parseCSVLine(csv)
        guard components.count >= 6 else {
            DDLogError("Failed to parse TodoItem csv.")
            return nil
        }
        
        let id = components[0]
        let text = components[1]
        let importance = Importance(rawValue: components[2]) ?? .normal
        let isDone = (components[3] as NSString).boolValue
        let creationDate = ISO8601DateFormatter().date(from: components[4])!
        let deadline = components[5].isEmpty ? nil : ISO8601DateFormatter().date(from: components[5])
        let modificationDate = components.count > 6 ? (components[6].isEmpty ? nil : ISO8601DateFormatter().date(from: components[6])) : nil
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: modificationDate
        )
    }
    
    private static func parseCSVLine(_ line: String) -> [String] {
        var components: [String] = []
        var currentComponent = ""
        var insideQuotes = false
        
        // Handling "," symbol inside quotes.
        for character in line {
            if character == "\"" {
                insideQuotes.toggle()
                continue
            }
            if character == "," && !insideQuotes {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(character)
            }
        }
        components.append(currentComponent)
        return components
    }
    
    public var csv: String {
        var components: [String] = [
            id,
            // Surround text with quotes to avoid parsing errors.
            "\"\(text.replacingOccurrences(of: "\"", with: "\"\""))\"",
            importance.rawValue,
            isDone ? "true" : "false",
            ISO8601DateFormatter().string(from: creationDate),
            deadline != nil ? ISO8601DateFormatter().string(from: deadline!) : ""
        ]
        if let modificationDate = modificationDate {
            components.append(ISO8601DateFormatter().string(from: modificationDate))
        }
        return components.joined(separator: ",")
    }
}
