//
//  GetAllItemsResponseModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 19.07.2024.
//

import Foundation

struct GetAllItemsResponseModel: Codable {
    let status: String
    let revision: Int
    let list: [TodoItemNetworkingModel]
}
