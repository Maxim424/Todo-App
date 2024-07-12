//
//  URLSession+dataTask.swift
//  todo_app
//
//  Created by Максим Кузнецов on 12.07.2024.
//

import Foundation

extension URLSession {
    func dataTask(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let data = data, let response = response else {
                    let error = URLError(.badServerResponse)
                    continuation.resume(throwing: error)
                    return
                }
                
                continuation.resume(returning: (data, response))
            }
            
            do {
                try Task.checkCancellation()
            } catch {
                task.cancel()
            }
            
            task.resume()
        }
    }
}
