//
//  GetItemResponseModel.swift
//  todo_app
//
//  Created by Максим Кузнецов on 20.07.2024.
//

import Foundation

struct GetItemResponseModel: Codable {
    let status: String
    let revision: Int
    let element: TodoItemNetworkingModel
}
