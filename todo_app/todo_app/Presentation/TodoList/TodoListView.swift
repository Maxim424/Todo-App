//
//  TodoListView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var context
    @State private var isShowingDetails = false
    @State private var isShowingAllItems = false
    @State private var isShowingCalendar = false
    @State private var currentModel: TodoItemModel? = nil
    @Query(filter: #Predicate<TodoItemModel> { !$0.isDone }, sort: [SortDescriptor(\TodoItemModel.modificationDate, order: .reverse)], animation: .snappy) private var activeList: [TodoItemModel]
    @Query(sort: [SortDescriptor(\TodoItemModel.modificationDate, order: .reverse)], animation: .snappy) private var fullList: [TodoItemModel]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(isShowingAllItems ? fullList : activeList) { item in
                        Button(action: {
                            currentModel = item
                            isShowingDetails = true
                        }, label: {
                            TodoRowView(model: item)
                        })
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                item.isDone.toggle()
                            }) {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button("", systemImage: "trash") {
                                context.delete(item)
                            }
                            .tint(.red)
                            Button(action: {
                                isShowingDetails = true
                            }) {
                                Image("i.circle.fill")
                            }
                            .tint(.gray)
                        }
                    }
                } header: {
                    HStack {
                        Text("Выполнено – \(fullList.count - activeList.count)")
                            .textCase(nil)
                        Spacer()
                        Button {
                            isShowingAllItems.toggle()
                        } label: {
                            Text(isShowingAllItems ? "hide" : "show")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .textCase(nil)
                        }

                    }
                }
            }
            .sheet(isPresented: $isShowingDetails) {
                if let currentModel {
                    DetailsView(model: currentModel)
                }
            }
            .navigationDestination(isPresented: $isShowingCalendar) {
                CalendarViewRepresentable()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingCalendar.toggle()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    CommonAddButton {
                        let todoItem = TodoItemModel(text: "", importance: .normal)
                        context.insert(todoItem)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("todo_list_view_title")
        }
    }
}

#Preview {
    TodoListView()
}
