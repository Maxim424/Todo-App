//
//  TodoListViewModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 04.07.2024.
//

import SwiftUI
import FileCache

final class TodoListViewModel: ObservableObject {
    @Published var isShowingDetails = false
    @Published var isShowingAllItems = false
    @Published var isShowingCalendar = false
    @Published var currentItem: TodoItem? = nil
    @Published var filteredList: [TodoItem] = []
    private var fileCache: FileCache
    private var completion: (() -> Void)?
    
    init(fileCache: FileCache, completion: (() -> Void)? = nil) {
        self.fileCache = fileCache
        self.completion = completion
    }
    
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
        fileCache.saveToFile(filename: FileCache.filename)
        fetchItems()
        completion?()
    }
    
    func eventUpdate(item: TodoItem) {
        if let index = fileCache.items.firstIndex(where: { $0.id == item.id }) {
            fileCache.items[index] = item
            fileCache.saveToFile(filename: FileCache.filename)
            fetchItems()
            completion?()
        }
    }
    
    func eventDelete(item: TodoItem) {
        if let index = fileCache.items.firstIndex(where: { $0.id == item.id }) {
            fileCache.items.remove(at: index)
            fileCache.saveToFile(filename: FileCache.filename)
            fetchItems()
        }
    }
    
    func eventShowButtonPressed() {
        isShowingAllItems.toggle()
        fetchItems()
    }
    
    private func fetchItems() {
        filteredList = fileCache.items
        if !isShowingAllItems {
            filteredList = filteredList.filter({ !$0.isDone })
        }
    }
}
