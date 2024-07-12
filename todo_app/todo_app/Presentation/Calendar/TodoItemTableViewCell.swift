//
//  TodoItemTableViewCell.swift
//  todo_app
//
//  Created by Максим Кузнецов on 06.07.2024.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {
    static var reuseIdentifier = "TodoItemTableViewCell"
    private let categoryView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubview(categoryView)
        categoryView.pin(to: contentView, [.right: 16])
        categoryView.pinCenterY(to: contentView)
        categoryView.setWidth(to: 16)
        categoryView.setHeight(to: 16)
        categoryView.layer.cornerRadius = 8
        categoryView.backgroundColor = .black
    }
    
    func configure(with todoItem: TodoItem) {
        var content = defaultContentConfiguration()
        
        if todoItem.isDone {
            let attributeString = NSMutableAttributedString(string: todoItem.text)
            let range = NSRange(location: 0, length: attributeString.length)
            attributeString.addAttributes([
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.gray
            ], range: range)
            content.attributedText = attributeString
        } else {
            content.text = todoItem.text
        }
        
        contentConfiguration = content
        setupCell()
        categoryView.backgroundColor = UIColor(rgb: todoItem.category.color)
    }
}
