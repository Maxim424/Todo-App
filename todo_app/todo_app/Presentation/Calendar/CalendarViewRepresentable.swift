//
//  CalendarViewRepresentable.swift
//  todo_app
//
//  Created by Максим Кузнецов on 02.07.2024.
//

import SwiftUI

struct CalendarViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CalendarViewController {
        return CalendarViewController()
    }

    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) { }
}
