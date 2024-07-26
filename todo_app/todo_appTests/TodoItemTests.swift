//
//  TodoItemTests.swift
//  todo_appTests
//
//  Created by Максим Кузнецов on 21.06.2024.
//

import XCTest
import FileCache
@testable import todo_app

final class TodoItemTests: XCTestCase {
    var fileCache: DefaultFileCache!

    override func setUpWithError() throws {
        fileCache = DefaultFileCache()
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
        XCTAssertNil(fileCache.items[2].modificationDate)
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
    
    func testParseCSV() {
        let csvString = "1,\"Item1 text\",normal,true,2024-06-21T00:00:00Z,2024-06-22T00:00:00Z"
        guard let item = TodoItem.parse(csv: csvString) else {
            XCTFail("Failed to parse CSV")
            return
        }
        
        XCTAssertEqual(item.id, "1")
        XCTAssertEqual(item.text, "Item1 text")
        XCTAssertEqual(item.importance, .normal)
        XCTAssertTrue(item.isDone)
        XCTAssertEqual(item.creationDate, ISO8601DateFormatter().date(from: "2024-06-21T00:00:00Z"))
        XCTAssertEqual(item.deadline, ISO8601DateFormatter().date(from: "2024-06-22T00:00:00Z"))
        XCTAssertNil(item.modificationDate)
    }
    
    func testCreateCSV() {
        let creationDate = ISO8601DateFormatter().date(from: "2024-06-21T00:00:00Z")!
        let deadline = ISO8601DateFormatter().date(from: "2024-06-22T00:00:00Z")!
        let item = TodoItem(
            id: "1",
            text: "Item1 text",
            importance: .important,
            deadline: deadline,
            isDone: true,
            creationDate: creationDate,
            modificationDate: nil
        )
        XCTAssertEqual(item.csv, "1,\"Item1 text\",important,true,2024-06-21T00:00:00Z,2024-06-22T00:00:00Z")
    }
}
