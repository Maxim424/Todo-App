//
//  TodoItem+JSON.swift
//  todo_app
//
//  Created by Максим Кузнецов on 20.06.2024.
//

import Foundation
import OSLog

extension TodoItem {
    static func parse(json: Any) -> TodoItem? {
        guard let dictionary = json as? [String: Any] else {
            Logger.services.warning("Failed to parse json.")
            return nil
        }
        
        guard let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let isDone = dictionary["isDone"] as? Bool,
              let creationDateString = dictionary["creationDate"] as? String,
              let creationDate = ISO8601DateFormatter().date(from: creationDateString),
              let categoryDict = dictionary["category"],
              let category = Category.parse(json: categoryDict)
        else {
            return nil
        }
        
        let importanceString = dictionary["importance"] as? String
        let importance: Importance = Importance(rawValue: importanceString ?? Importance.normal.rawValue) ?? .normal
        
        var deadline: Date? = nil
        if let deadlineString = dictionary["deadline"] as? String {
            deadline = ISO8601DateFormatter().date(from: deadlineString)
        }
        
        var modificationDate: Date? = nil
        if let modificationDateString = dictionary["modificationDate"] as? String {
            modificationDate = ISO8601DateFormatter().date(from: modificationDateString)
        }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: modificationDate,
            category: category
        )
    }
    
    var json: Any {
        var dictionary: [String: Any] = [
            "id": id,
            "text": text,
            "isDone": isDone,
            "creationDate": ISO8601DateFormatter().string(from: creationDate),
            "category": category.json
        ]
        
        if importance != .normal {
            dictionary["importance"] = importance.rawValue
        }
        
        if let deadline {
            dictionary["deadline"] = ISO8601DateFormatter().string(from: deadline)
        }
        
        if let modificationDate {
            dictionary["modificationDate"] = ISO8601DateFormatter().string(from: modificationDate)
        }
        
        return dictionary
    }
}
