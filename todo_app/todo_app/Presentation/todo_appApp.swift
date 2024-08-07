//
//  todo_appApp.swift
//  todo_app
//
//  Created by Максим Кузнецов on 20.06.2024.
//

import SwiftUI
import FileCache

@main
struct todo_appApp: App {
    @StateObject private var todoListViewModel = TodoListViewModel(fileCache: DefaultFileCache())
    
    var body: some Scene {
        WindowGroup {
            TodoListView()
                .environmentObject(todoListViewModel)
        }
    }
}
