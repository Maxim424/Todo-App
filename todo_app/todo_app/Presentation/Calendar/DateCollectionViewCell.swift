//
//  DateCollectionViewCell.swift
//  todo_app
//
//  Created by Максим Кузнецов on 03.07.2024.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    let borderView = UIView()
    let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 160, green: 160, blue: 160)
        label.layer.masksToBounds = true
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(borderView)
        borderView.pin(to: contentView)
        borderView.addSubview(textLabel)
        textLabel.pin(to: borderView)
        
        borderView.layer.cornerRadius = 10
        borderView.layer.borderWidth = 2
        borderView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            borderView.layer.borderColor = UIColor(red: 160, green: 160, blue: 160).cgColor
        } else {
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
