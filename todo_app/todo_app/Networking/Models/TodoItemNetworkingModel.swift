//
//  TodoItemNetworkingModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 19.07.2024.
//

import Foundation

struct TodoItemNetworkingModel: Codable {
    let id: UUID
    let text: String
    let importance: ImportanceNetworkingModel
    let deadline: Int64?
    let done: Bool
    let color: String?
    let createdAt: Int64
    let changedAt: Int64
    let lastUpdatedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id, text, importance, deadline, done, color
        case createdAt = "created_at"
        case changedAt = "changed_at"
        case lastUpdatedBy = "last_updated_by"
    }
}

enum ImportanceNetworkingModel: String, Codable {
    case low, basic, important
}
