//
//  FileCache.swift
//  todo_app
//
//  Created by Максим Кузнецов on 21.06.2024.
//

import Foundation
import CocoaLumberjackSwift

final class FileCache {
    static var filename = "todo_list.json"
    private var todoItems: [TodoItem] = []

    var items: [TodoItem] {
        get {
            todoItems
        }
        set {
            todoItems = newValue
        }
    }

    func addTodoItem(_ item: TodoItem) {
        if !todoItems.contains(where: { $0.id == item.id }) {
            todoItems.append(item)
        }
    }

    func removeTodoItem(by id: String) {
        todoItems.removeAll { $0.id == id }
    }

    func saveToFile(filename: String) {
        let jsonArray = todoItems.map { $0.json }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: [.prettyPrinted])
            let url = getDocumentsDirectory().appendingPathComponent(filename)
            try jsonData.write(to: url)
        } catch {
            DDLogError("Failed to save json.")
        }
    }

    func loadFromFile(filename: String) {
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
}
