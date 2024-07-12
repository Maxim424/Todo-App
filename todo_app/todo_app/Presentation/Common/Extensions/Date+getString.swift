//
//  Date+getString.swift
//  todo_app
//
//  Created by Максим Кузнецов on 02.07.2024.
//

import Foundation

extension Date {
    func getString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: self)
    }
}
