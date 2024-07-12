//
//  DetailsView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI
import FileCache

struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var viewModel: TodoListViewModel
    @State var text: String = ""
    @State var importance: Importance = .normal
    @State var isDeadlineSet: Bool = false
    @State var deadline: Date = (Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())
    
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
                        if let item = viewModel.currentItem {
                            viewModel.eventDelete(item: item)
                        }
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
                        if let item = viewModel.currentItem, item.text.isEmpty {
                            viewModel.eventDelete(item: item)
                        }
                        dismiss()
                    } label: {
                        Text("cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let item = viewModel.currentItem, text.isEmpty {
                            viewModel.eventDelete(item: item)
                        } else {
                            viewModel.currentItem?.modificationDate = .now
                            viewModel.currentItem?.text = text
                            viewModel.currentItem?.importance = importance
                            if isDeadlineSet {
                                viewModel.currentItem?.deadline = deadline
                            } else {
                                viewModel.currentItem?.deadline = nil
                            }
                            if let model = viewModel.currentItem {
                                viewModel.eventUpdate(item: model)
                            }
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
