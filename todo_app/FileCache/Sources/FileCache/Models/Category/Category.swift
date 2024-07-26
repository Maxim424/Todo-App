//
//  Category.swift
//  todo_app
//
//  Created by Максим Кузнецов on 06.07.2024.
//

import Foundation
import CocoaLumberjackSwift

public struct Category {
    public let name: String
    public let color: Int // hex representation
    
    public init(name: String, color: Int) {
        self.name = name
        self.color = color
    }
    
    public var json: Any {
        let dictionary: [String: Any] = [
            "name": name,
            "color": color
        ]
        return dictionary
    }
    
    public static func parse(json: Any) -> Category? {
        guard let dictionary = json as? [String: Any] else {
            DDLogError("Failed to parse Category json.")
            return nil
        }
        guard let name = dictionary["name"] as? String,
              let color = dictionary["color"] as? Int
        else {
            DDLogError("Failed to parse Category json.")
            return nil
        }
        return Category(
            name: name,
            color: color
        )
    }
    
    public static let presets: [CategoryPresets: Category] = [
        .work: .init(name: "работа", color: 0xFF3B31),
        .study: .init(name: "учеба", color: 0x0078FA),
        .hobby: .init(name: "хобби", color: 0x35C759),
        .other: .init(name: "другое", color: 0xA0A0A0)
    ]
    
    public enum CategoryPresets {
        case work
        case study
        case hobby
        case other
    }
}
