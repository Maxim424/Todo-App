//
//  NetworkingService.swift
//  todo_app
//
//  Created by Максим Кузнецов on 19.07.2024.
//

protocol NetworkingService {
    func getAllItems() async throws -> GetAllItemsResponseModel
    
    func addItem(item: TodoItemNetworkingModel, revision: Int) async throws
    
    func updateItem(item: TodoItemNetworkingModel, revision: Int) async throws
    
    func deleteItem(itemId: String, revision: Int) async throws
    
    func getItem(itemId: String) async throws -> GetItemResponseModel
    
    func patchItems(items: [TodoItemNetworkingModel], revision: Int) async throws
}
