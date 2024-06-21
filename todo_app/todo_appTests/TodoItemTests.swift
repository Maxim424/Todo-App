//
//  TodoItemTests.swift
//  todo_appTests
//
//  Created by Максим Кузнецов on 21.06.2024.
//

import XCTest
@testable import todo_app

final class TodoItemTests: XCTestCase {
    var fileCache: FileCache!

    override func setUpWithError() throws {
        fileCache = FileCache()
    }

    override func tearDownWithError() throws {
        fileCache = nil
    }
    
    func testAddTodoItem() throws {
        let item1 = TodoItem(
            text: "Item1 text",
            importance: .notImportant,
            deadline: Date(timeIntervalSinceNow: 10),
            isDone: false
        )
        let item2 = TodoItem(
            text: "Item2 text",
            importance: .normal,
            isDone: true
        )
        let item3 = TodoItem(
            text: "Item3 tex",
            importance: .important
        )
        
        fileCache.addTodoItem(item1)
        XCTAssertEqual(fileCache.items.count, 1)
        XCTAssertEqual(fileCache.items[0].importance, .notImportant)
        
        fileCache.addTodoItem(item2)
        XCTAssertEqual(fileCache.items.count, 2)
        XCTAssertEqual(fileCache.items[1].isDone, true)
        
        fileCache.addTodoItem(item3)
        XCTAssertEqual(fileCache.items.count, 3)
        XCTAssertEqual(fileCache.items[2].modificationDate, nil)
    }

    func testRemoveTodoItem() {
        let item1 = TodoItem(
            text: "Item1 text",
            importance: .notImportant,
            deadline: Date(timeIntervalSinceNow: 10),
            isDone: false
        )
        let item2 = TodoItem(
            text: "Item2 text",
            importance: .normal,
            isDone: true
        )
        
        fileCache.addTodoItem(item1)
        fileCache.addTodoItem(item2)
        
        XCTAssertEqual(fileCache.items.count, 2)
        
        fileCache.removeTodoItem(by: item1.id)
        
        XCTAssertEqual(fileCache.items.count, 1)
        XCTAssertEqual(fileCache.items.first?.text, "Item2 text")
    }

    func testSaveAndLoadFromFile() {
        let item1 = TodoItem(
            text: "Item1 text",
            importance: .notImportant,
            deadline: Date(timeIntervalSinceNow: 10),
            isDone: false
        )
        let item2 = TodoItem(
            text: "Item2 text",
            importance: .normal,
            isDone: true
        )
        fileCache.addTodoItem(item1)
        fileCache.addTodoItem(item2)
        XCTAssertEqual(fileCache.items.count, 2)
        
        let filename = "test.json"
        fileCache.saveToFile(filename: filename)
        fileCache.removeTodoItem(by: item1.id)
        fileCache.removeTodoItem(by: item2.id)
        XCTAssertEqual(fileCache.items.count, 0)
        
        fileCache.loadFromFile(filename: filename)
        XCTAssertEqual(fileCache.items.count, 2)
        XCTAssertTrue(fileCache.items.contains(where: { $0.text == "Item1 text" }))
        XCTAssertTrue(fileCache.items.contains(where: { $0.isDone }))
    }
}
