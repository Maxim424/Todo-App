//
//  PatchItemsRequestModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 20.07.2024.
//

struct PatchItemsRequestModel: Codable {
    let list: [TodoItemNetworkingModel]
}
