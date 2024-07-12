//
//  URLSessionTests.swift
//  todo_appTests
//
//  Created by Максим Кузнецов on 12.07.2024.
//

import XCTest
@testable import todo_app

class URLSessionTests: XCTestCase {
    func testAsyncDataTask() async throws {
        let url = URL(string: "https://apple.com")!
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.dataTask(for: request)
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
    }
    
    func testAsyncDataTaskCancellation() async {
        let url = URL(string: "https://apple.com")!
        let request = URLRequest(url: url)
        
        let task = Task {
            do {
                let _ = try await URLSession.shared.dataTask(for: request)
                XCTFail("Task should have been cancelled")
            } catch {
                XCTAssertTrue(error is URLError)
            }
        }
        
        task.cancel()
        await task.value
    }
}
