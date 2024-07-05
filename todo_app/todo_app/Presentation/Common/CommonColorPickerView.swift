//
//  CommonColorPickerView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 29.06.2024.
//

import SwiftUI

struct CommonColorPickerView: View {
    @State private var selectedColor = Color.red
    
    var body: some View {
        HStack {
            Text("Цвет")
            Spacer()
            ColorPicker(
                selection: $selectedColor,
                supportsOpacity: false
            ) { }
                .labelsHidden()
        }
    }
}

#Preview {
    CommonColorPickerView()
}
