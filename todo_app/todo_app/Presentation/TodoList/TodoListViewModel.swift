//
//  TodoListViewModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 04.07.2024.
//

import SwiftUI
import FileCache
import CocoaLumberjackSwift

@MainActor
final class TodoListViewModel: ObservableObject {
    @Published var isShowingDetails = false
    @Published var isShowingAllItems = false
    @Published var isShowingCalendar = false
    @Published var currentItem: TodoItem? = nil
    @Published var filteredList: [TodoItem] = []
    @Published var fileCacheList: [TodoItem] = []
    
    private var fileCache: FileCache
    private var completion: (() -> Void)?
    
    private var networkingService = DefaultNetworkingService()
    private var revision: Int = 0
    private var isDirty: Bool = false
    
    init(fileCache: FileCache, completion: (() -> Void)? = nil) {
        self.fileCache = fileCache
        self.completion = completion
    }
    
    func eventOnAppear() {
        Task {
            await fetchItems()
            await fetchItemsFromServer()
        }
//        
//        fileCache.loadFromFile(filename: FileCache.filename)
//        fetchItems()
    }
    
    func eventOnDisappear() {
        fileCache.saveToFile(filename: FileCache.filename)
    }
    
    func eventTodoItemPressed(item: TodoItem) {
        currentItem = item
        isShowingDetails = true
    }
    
    func eventAdd(item: TodoItem) {
        Task {
            await fetchItems()
            await addItemToServer(item)
            await fetchItemsFromServer()
        }
        
//        fileCache.addTodoItem(item)
//        fileCache.saveToFile(filename: FileCache.filename)
//        completion?()
    }
    
    func eventUpdate(item: TodoItem) {
        Task {
            await fetchItems()
            await updateItemOnServer(item)
            await getItemFromServer(item)
        }
//        if let index = fileCache.items.firstIndex(where: { $0.id == item.id }) {
//            fileCache.items[index] = item
//            fileCache.saveToFile(filename: FileCache.filename)
//            completion?()
//        }
    }
    
    func eventDelete(item: TodoItem) {
        Task {
            await fetchItems()
            await  deleteItemFromServer(item)
            await fetchItemsFromServer()
        }
//        if let index = fileCache.items.firstIndex(where: { $0.id == item.id }) {
//            fileCache.items.remove(at: index)
//            fileCache.saveToFile(filename: FileCache.filename)
//        }
    }
    
    func eventShowButtonPressed() {
        isShowingAllItems.toggle()
        Task {
            await fetchItemsFromServer()
        }
    }
    
    private func fetchItems() async {
        fileCache.loadFromFile(filename: FileCache.filename)
        fileCacheList = fileCache.items
        if isDirty {
            await patchItemsOnServer(fileCacheList)
        }
    }
    
    private func fetchItemsFromServer() async {
        do {
            let responseModel = try await networkingService.getAllItems()
            filteredList = responseModel.list.map {
                var deadline: Date? = nil
                if let interval = $0.deadline {
                    deadline = Date(timeIntervalSince1970: TimeInterval(interval))
                }
                return .init(
                    id: $0.id.uuidString,
                    text: $0.text,
                    importance: Mapper.importanceToUI($0.importance),
                    deadline: deadline,
                    isDone: $0.done,
                    creationDate: Date(timeIntervalSince1970: TimeInterval($0.createdAt)),
                    modificationDate: Date(timeIntervalSince1970: TimeInterval($0.changedAt)),
                    category: .presets[.other] ?? .init(name: "другое", color: 0xA0A0A0)
                )
            }
            if !isShowingAllItems {
                filteredList = filteredList.filter({ !$0.isDone })
            }
            revision = responseModel.revision
            isDirty = false
        } catch {
            isDirty = true
            DDLogError("Failed to fetch items from server.")
        }
    }
    
    private func addItemToServer(_ item: TodoItem) async {
        var deadline: Int64? = nil
        if let interval = item.deadline?.timeIntervalSince1970 {
            deadline = Int64(interval)
        }
        let todoItemNetworkingModel = TodoItemNetworkingModel(
            id: UUID(uuidString: item.id) ?? UUID(),
            text: item.text,
            importance: Mapper.importanceToNetworking(item.importance),
            deadline: deadline,
            done: item.isDone,
            color: nil,
            createdAt: Int64(item.creationDate.timeIntervalSince1970),
            changedAt: Int64(item.modificationDate?.timeIntervalSince1970 ?? 0),
            lastUpdatedBy: "1"
        )
        do {
            try await networkingService.addItem(item: todoItemNetworkingModel, revision: revision)
        } catch {
            isDirty = true
            DDLogError("Failed to add item to server.")
        }
    }
    
    private func updateItemOnServer(_ item: TodoItem) async {
        var deadline: Int64? = nil
        if let interval = item.deadline?.timeIntervalSince1970 {
            deadline = Int64(interval)
        }
        let todoItemNetworkingModel = TodoItemNetworkingModel(
            id: UUID(uuidString: item.id) ?? UUID(),
            text: item.text,
            importance: Mapper.importanceToNetworking(item.importance),
            deadline: deadline,
            done: item.isDone,
            color: nil,
            createdAt: Int64(item.creationDate.timeIntervalSince1970),
            changedAt: Int64(item.modificationDate?.timeIntervalSince1970 ?? 0),
            lastUpdatedBy: "1"
        )
        do {
            try await networkingService.updateItem(item: todoItemNetworkingModel, revision: revision)
        } catch {
            isDirty = true
            DDLogError("Failed to update item on server.")
        }
    }
    
    private func deleteItemFromServer(_ item: TodoItem) async {
        do {
            try await networkingService.deleteItem(itemId: item.id, revision: revision)
        } catch {
            isDirty = true
            DDLogError("Failed to delete item from server.")
        }
    }
    
    private func getItemFromServer(_ item: TodoItem) async {
        do {
            let responseModel = try await networkingService.getItem(itemId: item.id)
            if let index = filteredList.firstIndex(where: { $0.id == responseModel.element.id.uuidString }) {
                var deadline: Date? = nil
                if let interval = responseModel.element.deadline {
                    deadline = Date(timeIntervalSince1970: TimeInterval(interval))
                }
                filteredList[index] = .init(
                    id: responseModel.element.id.uuidString,
                    text: responseModel.element.text,
                    importance: Mapper.importanceToUI(responseModel.element.importance),
                    deadline: deadline,
                    isDone: responseModel.element.done,
                    creationDate: Date(timeIntervalSince1970: TimeInterval(responseModel.element.createdAt)),
                    modificationDate: Date(timeIntervalSince1970: TimeInterval(responseModel.element.changedAt)),
                    category: .presets[.other] ?? .init(name: "другое", color: 0xA0A0A0)
                )
            }
            revision = responseModel.revision
        } catch {
            isDirty = true
            DDLogError("Failed to get item from server.")
        }
    }
    
    private func patchItemsOnServer(_ items: [TodoItem]) async {
        let itemsNetworkingModel: [TodoItemNetworkingModel] = items.map {
            var deadline: Int64? = nil
            if let interval = $0.deadline?.timeIntervalSince1970 {
                deadline = Int64(interval)
            }
            return TodoItemNetworkingModel(
                id: UUID(uuidString: $0.id) ?? UUID(),
                text: $0.text,
                importance: Mapper.importanceToNetworking($0.importance),
                deadline: deadline,
                done: $0.isDone,
                color: nil,
                createdAt: Int64($0.creationDate.timeIntervalSince1970),
                changedAt: Int64($0.modificationDate?.timeIntervalSince1970 ?? 0),
                lastUpdatedBy: "1"
            )
        }
        do {
            try await networkingService.patchItems(items: itemsNetworkingModel, revision: revision)
        } catch {
            isDirty = true
            DDLogError("Failed to patch items on server.")
        }
    }
}
