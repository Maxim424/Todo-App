//
//  CommonDatePickerView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI

struct CommonDatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isToggleOn: Bool
    @State var showDatePicker = false

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                    if isToggleOn {
                        Button {
                            if isToggleOn {
                                showDatePicker.toggle()
                            }
                        } label: {
                            Text("\(selectedDate.getString())")
                        }
                    }
                }
                Spacer()
                Toggle(isOn: $isToggleOn) {
                    Text("")
                }
                .labelsHidden()
                .onChange(of: isToggleOn) { _, newValue in
                    if !newValue {
                        showDatePicker = false
                    }
                }
            }
            if showDatePicker && isToggleOn {
                Divider()
                DatePicker(
                    selection: $selectedDate,
                    displayedComponents: [.date]
                ) { }
                    .labelsHidden()
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding(.horizontal)
                    .onChange(of: selectedDate) {
                        showDatePicker = false
                    }
            }
        }
    }
}
