//
//  DefaultNetworkingService.swift
//  todo_app
//
//  Created by Максим Кузнецов on 19.07.2024.
//

import Foundation

final class DefaultNetworkingService: NetworkingService, @unchecked Sendable {
    private let token = "" // replace with your token to test.
    
    func getAllItems() async throws -> GetAllItemsResponseModel {
        guard let url = URL(string: "https://hive.mrdekk.ru/todo/list") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let model = try JSONDecoder().decode(GetAllItemsResponseModel.self, from: data)
        return model
    }

    func addItem(item: TodoItemNetworkingModel, revision: Int) async throws {
        let addItemRequestModel = AddItemRequestModel(element: item)
        
        guard let url = URL(string: "https://hive.mrdekk.ru/todo/list") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let jsonData = try JSONEncoder().encode(addItemRequestModel)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    func updateItem(item: TodoItemNetworkingModel, revision: Int) async throws {
        let updateItemRequestModel = UpdateItemRequestModel(element: item)
        
        guard let url = URL(string: "https://hive.mrdekk.ru/todo/list/\(item.id.uuidString)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let jsonData = try JSONEncoder().encode(updateItemRequestModel)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print(response)
            throw URLError(.badServerResponse)
        }
    }
    
    func deleteItem(itemId: String, revision: Int) async throws {
        guard let url = URL(string: "https://hive.mrdekk.ru/todo/list/\(itemId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print(response)
            throw URLError(.badServerResponse)
        }
    }
    
    func getItem(itemId: String) async throws -> GetItemResponseModel {
        guard let url = URL(string: "https://hive.mrdekk.ru/todo/list/\(itemId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let model = try JSONDecoder().decode(GetItemResponseModel.self, from: data)
        return model
    }
    
    func patchItems(items: [TodoItemNetworkingModel], revision: Int) async throws {
        let patchItemsRequestModel = PatchItemsRequestModel(list: items)
        
        guard let url = URL(string: "https://hive.mrdekk.ru/todo/list") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("\(revision)", forHTTPHeaderField: "X-Last-Known-Revision")
        
        let jsonData = try JSONEncoder().encode(patchItemsRequestModel)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print(response)
            throw URLError(.badServerResponse)
        }
    }
}
