//
//  Mapper.swift
//  todo_app
//
//  Created by Максим Кузнецов on 19.07.2024.
//

import Foundation
import FileCache

final class Mapper {
    static func importanceToUI(_ importance: ImportanceNetworkingModel) -> Importance {
        switch importance {
        case .low:
            return .notImportant
        case .basic:
            return .normal
        case .important:
            return .important
        }
    }
    
    static func importanceToNetworking(_ importance: Importance) -> ImportanceNetworkingModel {
        switch importance {
        case .notImportant:
            return .low
        case .normal:
            return .basic
        case .important:
            return .important
        }
    }
}
