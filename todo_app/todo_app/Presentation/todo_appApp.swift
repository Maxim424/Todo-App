//
//  todo_appApp.swift
//  todo_app
//
//  Created by Максим Кузнецов on 20.06.2024.
//

import SwiftUI

@main
struct todo_appApp: App {
    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
        .modelContainer(for: TodoItemModel.self)
    }
}
