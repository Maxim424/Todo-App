//
//  CalendarViewController.swift
//  todo_app
//
//  Created by Максим Кузнецов on 02.07.2024.
//

import UIKit
import SwiftUI
import FileCache

final class CalendarViewController: UIViewController {
    private  let fileCache = FileCache()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let addButton = UIButton(type: .system)
    private var selectedDateIndex = 0
    private var tableViewData: [TodoItem] = []
    private var collectionViewData: [String] = []
    private var filteredData: [[TodoItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fileCache.saveToFile(filename: FileCache.filename)
    }
    
    private func setupView() {
        setupCollectionView()
        setupTableView()
        setupAddButton()
    }
    
    private func setupAddButton() {
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: boldConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        addButton.setImage(image, for: .normal)
        addButton.setWidth(to: 44)
        addButton.setHeight(to: 44)
        addButton.layer.cornerRadius = 22
        addButton.clipsToBounds = true
        addButton.backgroundColor = .systemBlue
        addButton.tintColor = .white
        
        view.addSubview(addButton)
        addButton.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 20)
        addButton.pinCenterX(to: view)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        
        self.view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.left, .right])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        collectionView.setHeight(to: 90)
        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        let bottomBorder = UIView()
        collectionView.addSubview(bottomBorder)
        bottomBorder.pin(to: collectionView, [.left, .right])
        bottomBorder.pinCenterY(to: collectionView)
        bottomBorder.setHeight(to: 10)
        bottomBorder.backgroundColor = .red
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.pin(to: view, [.left, .right, .bottom])
        tableView.pinTop(to: collectionView.bottomAnchor)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: TodoItemTableViewCell.reuseIdentifier)
    }
    
    private func fetchData() -> [TodoItem] {
        fileCache.loadFromFile(filename: FileCache.filename)
        return fileCache.items
    }
    
    private func processTodoItems(_ items: [TodoItem]) -> [[TodoItem]] {
        var groupedItems: [DateComponents?: [TodoItem]] = [:]
        for item in items {
            if let date = item.deadline {
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                if groupedItems[components] != nil {
                    groupedItems[components]?.append(item)
                } else {
                    groupedItems[components] = [item]
                }
            } else {
                if groupedItems[nil] != nil {
                    groupedItems[nil]?.append(item)
                } else {
                    groupedItems[nil] = [item]
                }
            }
        }
        var result = Array(groupedItems.values)
        result = result.sorted(by: {
            $0.first?.deadline ?? .distantFuture < $1.first?.deadline ?? .distantFuture
        })
        return result
    }
    
    private func processDates(_ items: [[TodoItem]]) -> [String] {
        var result: [String] = []
        for item in items {
            result.append(item.first?.deadline?.getString() ?? "Другое")
        }
        return result
    }
    
    private func fetch() {
        tableViewData = fetchData()
        filteredData = processTodoItems(tableViewData)
        collectionViewData = processDates(filteredData)
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    @objc
    private func addButtonPressed() {
        let item = TodoItem(text: "", importance: .normal)
        fileCache.addTodoItem(item)
        fileCache.saveToFile(filename: FileCache.filename)
        let viewModel = TodoListViewModel(fileCache: fileCache) { [weak self] in
            self?.fetch()
        }
        viewModel.currentItem = item
        let detailsView = DetailsView().environmentObject(viewModel)
        let controller = UIHostingController(rootView: detailsView)
        navigationController?.present(controller, animated: true)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prev = selectedDateIndex
        selectedDateIndex = indexPath.row
        collectionView.reloadItems(at: [.init(row: prev, section: 0)])
        collectionView.reloadItems(at: [.init(row: selectedDateIndex, section: 0)])
        tableView.scrollToRow(at: .init(row: 0, section: indexPath.row), at: .top, animated: true)
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.frame.height - 20
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell", for: indexPath) as! DateCollectionViewCell
        cell.textLabel.text = collectionViewData[indexPath.row].replacingOccurrences(of: " ", with: "\n")
        cell.setSelected(selectedDateIndex == indexPath.row)
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Done") { [weak self] (action, view, completionHandler) in
            self?.filteredData[indexPath.section][indexPath.row].isDone.toggle()
            let item = self?.filteredData[indexPath.section][indexPath.row]
            if let item {
                if let index = self?.fileCache.items.firstIndex(where: { $0.id == item.id }) {
                    self?.fileCache.items[index] = item
                    self?.fileCache.saveToFile(filename: FileCache.filename)
                }
            }
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
           
        }
        action.backgroundColor = UIColor(red: 0.2, green: 0.84, blue: 0.29, alpha: 1.0)
        action.image = UIImage(systemName: "checkmark.circle.fill")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            var actionsArray: [UIAction] = []
            for item in Category.presets.values {
                let action = UIAction(title: item.name) { [weak self] _ in
                    self?.filteredData[indexPath.section][indexPath.row].category = item
                    self?.fileCache.saveToFile(filename: FileCache.filename)
                    DispatchQueue.main.async {
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                actionsArray.append(action)
            }
            return UIMenu(title: "Применить категорию", children: actionsArray)
        }
    }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredData[section].first?.deadline?.getString() ?? "Другое"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemTableViewCell.reuseIdentifier, for: indexPath) as? TodoItemTableViewCell else { return UITableViewCell() }
        cell.configure(with: filteredData[indexPath.section][indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === tableView {
            if let row = tableView.indexPathsForVisibleRows?.first?.section {
                collectionView.scrollToItem(
                    at: .init(row: row, section: 0),
                    at: .left,
                    animated: true
                )
                let prev = selectedDateIndex
                selectedDateIndex = row
                collectionView.reloadItems(at: [.init(row: prev, section: 0)])
                collectionView.reloadItems(at: [.init(row: selectedDateIndex, section: 0)])
            }
        }
    }
}
