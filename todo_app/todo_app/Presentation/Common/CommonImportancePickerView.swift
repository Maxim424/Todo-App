//
//  CommonImportancePickerView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI

struct CommonImportancePickerView: View {
    @Binding var selectedSegment: Importance
    
    var body: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker(selection: $selectedSegment) {
                Image("arrow.down")
                    .tag(Importance.notImportant)
                Text("no_segment_title")
                    .tag(Importance.normal)
                Image("exclamationmark.2")
                    .tag(Importance.important)
            } label: { }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 150)
        }
    }
}
