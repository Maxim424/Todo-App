//
//  TodoLastRowButton.swift
//  todo_app
//
//  Created by Максим Кузнецов on 06.07.2024.
//

import SwiftUI

struct TodoLastRowButton: View {
    var action: (() -> ())?
    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                Text("Новое")
                    .foregroundStyle(Color.gray)
                Spacer()
            }
            .padding(.leading, 24)
        }
    }
}

#Preview {
    TodoLastRowButton()
}
