//
//  TodoItem.swift
//  todo_app
//
//  Created by Максим Кузнецов on 20.06.2024.
//

import Foundation

public enum Importance: String, Codable, CaseIterable {
    case notImportant
    case normal
    case important
}

public struct TodoItem: Identifiable {
    public let id: String
    public var text: String
    public var importance: Importance
    public var deadline: Date?
    public var isDone: Bool
    public var creationDate: Date
    public var modificationDate: Date?
    public var category: Category
    
    public init(
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
