//
//  TodoItem.swift
//  todo_app
//
//  Created by Максим Кузнецов on 20.06.2024.
//

import Foundation

enum Importance: String, Codable, CaseIterable {
    case notImportant
    case normal
    case important
}

struct TodoItem: Identifiable {
    let id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    var creationDate: Date
    var modificationDate: Date?
    var category: Category
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance,
        deadline: Date? = nil,
        isDone: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil,
        category: Category = Category.presets[.other] ?? .init(name: "", color: 0)
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.category = category
    }
}
