//
//  TodoRowView.swift
//  todo_app
//
//  Created by Максим Кузнецов on 28.06.2024.
//

import SwiftUI
import FileCache

struct TodoRowView: View {
    @Binding var model: TodoItem
    @EnvironmentObject private var viewModel: TodoListViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            if !model.text.isEmpty {
                checkButton
                importanceView()
            }
            VStack(alignment: .leading) {
                textField
                if model.deadline != nil {
                    deadlineView
                }
            }
            Spacer()
            if !model.text.isEmpty {
                rightChevron
            }
        }
        .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
        .onSubmit(of: .text) {
            if model.text.isEmpty {
                viewModel.eventDelete(item: model)
            }
        }
    }
    
    private var textField: some View {
        TextField("Новое", text: $model.text)
            .strikethrough(model.isDone)
            .font(.body)
            .foregroundStyle(model.isDone ? .gray : .primary)
    }
    
    private var deadlineView: some View {
        HStack(spacing: 2) {
            Image(systemName: "calendar")
                .foregroundStyle(.gray)
                .font(.subheadline)
            Text("\(model.deadline?.getString() ?? "")")
                .foregroundStyle(.gray)
                .font(.subheadline)
        }
    }
    
    @ViewBuilder
    private func importanceView() -> some View {
        if model.importance == .important {
            Image("exclamationmark.2")
        } else if model.importance == .notImportant {
            Image("arrow.down")
        }
    }
    
    private var checkButton: some View {
        Button(action: {
            model.isDone.toggle()
            viewModel.eventUpdate(item: model)
        }, label: {
            Image(systemName: model.isDone ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(model.isDone ? .green : .gray)
                .contentTransition(.symbolEffect(.replace))
        })
    }
    
    private var rightChevron: some View {
        Image(systemName: "chevron.right")
            .foregroundStyle(Color.gray)
    }
}

#Preview {
    TodoListView()
}
