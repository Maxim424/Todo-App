//
//  TodoItemModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 29.06.2024.
//

import SwiftUI
import SwiftData

@Model
class TodoItemModel {
    private(set) var id: String = UUID().uuidString
    var text: String
    var isDone: Bool = false
    var importance: Importance = Importance.normal
    var modificationDate: Date = Date.now
    var deadline: Date? = nil
    
    init(text: String, importance: Importance) {
        self.text = text
        self.importance = importance
    }
}
