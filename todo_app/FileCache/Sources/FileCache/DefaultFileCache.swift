//
//  FileCache.swift
//  todo_app
//
//  Created by Максим Кузнецов on 21.06.2024.
//

import Foundation
import CocoaLumberjack
import CocoaLumberjackSwift
import SwiftData

@available(iOS 17, *)
final public class DefaultFileCache: FileCache {
    public static let filename = "todo_list.json"
    private var todoItems: [TodoItem] = []
    
    private var todoItemsEntity: [TodoItemEntity] = []
    private let container: ModelContainer
    
    public init() {
        do {
            container = try ModelContainer(for: TodoItemEntity.self)
        } catch {
            fatalError("Failed to setup model container.")
        }
    }

    public var items: [TodoItem] {
        get {
            todoItems
        }
        set {
            todoItems = newValue
        }
    }

    public func addTodoItem(_ item: TodoItem) {
        if !todoItems.contains(where: { $0.id == item.id }) {
            todoItems.append(item)
        }
    }

    public func removeTodoItem(by id: String) {
        todoItems.removeAll { $0.id == id }
    }

    public func saveToFile(filename: String) {
        let jsonArray = todoItems.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [.prettyPrinted])
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            try jsonData.write(to: url)
        } catch {
            DDLogError("Failed to save json.")
        }
    }

    public func loadFromFile(filename: String) {
        let url = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let jsonData = try Data(contentsOf: url)
            guard let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]]
            else {
                DDLogError("Failed to load json from file.")
                return
            }
            todoItems = jsonArray.compactMap { TodoItem.parse(json: $0) }
        } catch {
            DDLogError("Failed to load json from file.")
        }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // MARK: SwiftData functions.
    
    private func createTodoItemEntity(_ todoItem: TodoItem) -> TodoItemEntity {
        let todoItemEntity = TodoItemEntity(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isDone: todoItem.isDone,
            creationDate: todoItem.creationDate,
            modificationDate: todoItem.modificationDate,
            category: todoItem.category
        )
        return todoItemEntity
    }
    
    @MainActor
    public func insert(_ todoItem: TodoItem) {
        let entity = createTodoItemEntity(todoItem)
        do {
            Task {
                await try container.mainContext.insert(entity)
            }
        } catch {
            DDLogError("Failed to insert todo item: \(error)")
        }
        
        do {
            try container.mainContext.save()
        } catch {
            DDLogError("Sample data context failed to save.")
        }
    }
    
    @MainActor
    public func fetch() async -> [TodoItem] {
        do {
            let enitities: [TodoItemEntity] = try await container.mainContext.fetch(.init())
            return enitities.map { entity in
                return TodoItem(
                    id: entity.id,
                    text: entity.text,
                    importance: entity.importance,
                    deadline: entity.deadline,
                    isDone: entity.isDone,
                    creationDate: entity.creationDate,
                    modificationDate: entity.modificationDate,
                    category: .presets[.other] ?? .init(name: "другое", color: 0xA0A0A0)
                )
            }
        } catch {
            DDLogError("Failed to fetch todo items: \(error)")
            return []
        }
    }
    
    @MainActor
    public func delete(_ todoItem: TodoItem) {
        do {
            Task {
                let collection: [TodoItemEntity] = try await container.mainContext.fetch(.init())
                for i in collection.indices {
                    if collection[i].id == todoItem.id {
                        await try container.mainContext.delete(collection[i])
                        break
                    }
                }
            }
        } catch {
            DDLogError("Failed to delete todo item: \(error)")
        }
        
        do {
            try container.mainContext.save()
        } catch {
            DDLogError("Sample data context failed to save.")
        }
    }
    
    @MainActor
    public func update(_ todoItem: TodoItem) {
        let entity = createTodoItemEntity(todoItem)
        do {
            Task {
                let collection: [TodoItemEntity] = try await container.mainContext.fetch(.init())
                for i in collection.indices {
                    if collection[i].id == entity.id {
                        collection[i].text = entity.text
                        collection[i].importance = entity.importance
                        collection[i].deadline = entity.deadline
                        collection[i].isDone = entity.isDone
                        collection[i].creationDate = entity.creationDate
                        collection[i].modificationDate = entity.modificationDate
                        break
                    }
                }
            }
        } catch {
            DDLogError("Failed to update todo item: \(error)")
        }
        
        do {
            try container.mainContext.save()
        } catch {
            DDLogError("Sample data context failed to save.")
        }
    }
}

@available(iOS 17, *)
@Model
class TodoItemEntity {
    @Attribute(.unique) public var id: String
    var text: String
    var importance: Importance
    var deadline: Date?
    var isDone: Bool
    var creationDate: Date
    var modificationDate: Date?
    
    init(
        id: String,
        text: String,
        importance: Importance,
        deadline: Date?,
        isDone: Bool,
        creationDate: Date,
        modificationDate: Date?,
        category: Category
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}
