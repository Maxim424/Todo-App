//
//  TodoListViewModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 04.07.2024.
//

import SwiftUI

final class TodoListViewModel: ObservableObject {
    @Published var isShowingDetails = false
    @Published var isShowingAllItems = false
    @Published var isShowingCalendar = false
    @Published var currentItem: TodoItem? = nil
    @Published var filteredList: [TodoItem] = []
    private var fileCache = FileCache()
    
    func eventOnAppear() {
        fileCache.loadFromFile(filename: FileCache.filename)
        fetchItems()
    }
    
    func eventOnDisappear() {
        fileCache.saveToFile(filename: FileCache.filename)
    }
    
    func eventTodoItemPressed(item: TodoItem) {
        currentItem = item
        isShowingDetails = true
    }
    
    func eventAdd(item: TodoItem) {
        fileCache.addTodoItem(item)
        fetchItems()
    }
    
    func eventUpdate(item: TodoItem) {
        if let index = fileCache.items.firstIndex(where: { $0.id == item.id }) {
            fileCache.items[index] = item
            fetchItems()
        }
    }
    
    private func fetchItems() {
        filteredList = fileCache.items
    }
}
