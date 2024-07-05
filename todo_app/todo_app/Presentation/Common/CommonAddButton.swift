//
//  CommonAddButton.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI

struct CommonAddButton: View {
    var action: (() -> ())?
    
    var body: some View {
        Button(action: {
            action?()
        }, label: {
            Image(systemName: "plus")
                .bold()
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 20, y: 8)
        })
    }
}

#Preview {
    CommonAddButton()
}
