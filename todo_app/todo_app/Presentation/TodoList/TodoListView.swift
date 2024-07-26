//
//  TodoListView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI
import FileCache

struct TodoListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var viewModel: TodoListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                mainView
                VStack {
                    Spacer()
                    CommonAddButton {
                        let item = TodoItem(text: "", importance: .normal)
                        viewModel.eventAdd(item: item)
                        viewModel.eventTodoItemPressed(item: item)
                    }
                    .padding(.bottom, 20)
                }
            }
            .onAppear {
                viewModel.eventOnAppear()
            }
            .sheet(isPresented: $viewModel.isShowingDetails) {
                DetailsView()
            }
            .navigationDestination(isPresented: $viewModel.isShowingCalendar) {
                CalendarViewRepresentable()
                    .navigationTitle("Календарь")
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea(.all)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowingCalendar.toggle()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
            .navigationTitle("todo_list_view_title")
        }
    }
    
    private var mainView: some View {
        List {
            Section {
                ForEach(viewModel.filteredList.indices, id: \.self) { i in
                    Button {
                        viewModel.eventTodoItemPressed(item: viewModel.filteredList[i])
                    } label: {
                        TodoRowView(model: $viewModel.filteredList[i])
                    }
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            viewModel.filteredList[i].isDone.toggle()
                            viewModel.eventUpdate(item: viewModel.filteredList[i])
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .tint(.green)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("", systemImage: "trash") {
                            viewModel.eventDelete(item: viewModel.filteredList[i])
                        }
                        .tint(.red)
                        Button(action: {
                            viewModel.isShowingDetails = true
                        }) {
                            Image("i.circle.fill")
                        }
                        .tint(.gray)
                    }
                }
                TodoLastRowButton {
                    let item = TodoItem(text: "", importance: .normal)
                    viewModel.eventAdd(item: item)
                    viewModel.eventTodoItemPressed(item: item)
                }
            } header: {
                HStack {
                    Text("Выполнено – \(viewModel.filteredList.filter { $0.isDone }.count)")
                        .textCase(nil)
                    Spacer()
                    Button {
                        viewModel.eventShowButtonPressed()
                    } label: {
                        Text(viewModel.isShowingAllItems ? "hide" : "show")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .textCase(nil)
                    }

                }
            }
            Spacer()
                .frame(height: 20)
                .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    TodoListView()
}
