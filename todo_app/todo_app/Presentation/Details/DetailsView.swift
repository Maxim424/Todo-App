//
//  DetailsView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI

struct DetailsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var viewModel: TodoListViewModel
    @State var text: String = ""
    @State var importance: Importance = .normal
    @State var isDeadlineSet: Bool = false
    @State var deadline: Date = .now
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    textEditor
                }
                Section {
                    CommonImportancePickerView(selectedSegment: $importance)
                    CommonDatePickerView(selectedDate: $deadline, isToggleOn: $isDeadlineSet)
                }
                Section {
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Удалить")
                                .foregroundStyle(Color.red)
                            Spacer()
                        }
                    })
                }
            }
            .navigationTitle("details_view_title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.currentItem?.modificationDate = .now
                        viewModel.currentItem?.text = text
                        viewModel.currentItem?.importance = importance
                        if isDeadlineSet {
                            viewModel.currentItem?.deadline = deadline
                        } else {
                            viewModel.currentItem?.deadline = nil
                        }
                        dismiss()
                    } label: {
                        Text("save")
                            .fontWeight(.semibold)
                    }
                }
            }
            .onAppear {
                text = viewModel.currentItem?.text ?? ""
                importance = viewModel.currentItem?.importance ?? .normal
                if let deadline = viewModel.currentItem?.deadline {
                    isDeadlineSet = true
                    self.deadline = deadline
                }
            }
        }
    }
    
    private var textEditor: some View {
        TextEditor(text: $text)
            .frame(minHeight: 120, maxHeight: .infinity)
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text("text_field_placeholder")
                        .foregroundStyle(.gray)
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
            }
    }
}

#Preview {
    TodoListView()
}
