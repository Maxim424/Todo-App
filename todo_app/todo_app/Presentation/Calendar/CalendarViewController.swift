//
//  CalendarViewController.swift
//  todo_app
//
//  Created by Максим Кузнецов on 02.07.2024.
//

import UIKit

final class CalendarViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var collectionView: UICollectionView!
    private var selectedDateIndex = 0
    private let tableViewData: [TodoItem] = [
        .init(
            text: "todo1!",
            importance: .normal,
            modificationDate: ISO8601DateFormatter().date(from: "2024-06-21T00:00:00Z")
        ),
        .init(
            text: "todo2! dsfgnbhgfr",
            importance: .normal,
            modificationDate: ISO8601DateFormatter().date(from: "2024-06-22T00:00:00Z")
        ),
        .init(
            text: "dfgb todo3!",
            importance: .normal,
            modificationDate: ISO8601DateFormatter().date(from: "2024-06-22T00:00:00Z")
        ),
        .init(
            text: "todfdvao4!",
            importance: .important,
            modificationDate: ISO8601DateFormatter().date(from: "2024-06-23T00:00:00Z")
        ),
        .init(
            text: "todo5!",
            importance: .notImportant,
            modificationDate: ISO8601DateFormatter().date(from: "2024-06-24T00:00:00Z")
        ),
        .init(text: "todo6", importance: .normal),
        .init(text: "todo7!", importance: .important),
        .init(text: "todo8!", importance: .normal),
        .init(text: "todo9!", importance: .normal),
        .init(text: "todo10!", importance: .normal),
        .init(text: "todo11!", importance: .normal),
        .init(text: "todo12!", importance: .normal),
        .init(text: "todo13!", importance: .normal),
        .init(text: "todo14!", importance: .normal),
        .init(text: "todo15", importance: .normal),
    ]
    private var collectionViewData: [String] = []
    private var filteredData: [[TodoItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredData = processTodoItems(tableViewData)
        collectionViewData = processDates(filteredData)
        tableView.reloadData()
    }
    
    private func setupView() {
        setupCollectionView()
        setupTableView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 247, green: 246, blue: 242)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "DateCollectionViewCell")
        
        self.view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.left, .right])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        collectionView.setHeight(to: 80)
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
        tableView.backgroundColor = UIColor(red: 247, green: 246, blue: 242)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    private func processTodoItems(_ items: [TodoItem]) -> [[TodoItem]] {
        var groupedItems: [Date?: [TodoItem]] = [:]
        for item in items {
            let date = item.modificationDate
            if groupedItems[date] != nil {
                groupedItems[date]?.append(item)
            } else {
                groupedItems[date] = [item]
            }
        }
        var result = Array(groupedItems.values)
        result = result.sorted(by: {
            $0.first?.modificationDate ?? Date() < $1.first?.modificationDate ?? Date()
        })
        return result
    }
    
    private func processDates(_ items: [[TodoItem]]) -> [String] {
        var result: [String] = []
        for item in items {
            result.append(item.first?.modificationDate?.getString() ?? "Другое")
        }
        return result
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
}

extension CalendarViewController: UICollectionViewDelegate {
    
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
        cell.textLabel.text = collectionViewData[indexPath.row]
        cell.setSelected(selectedDateIndex == indexPath.row)
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return filteredData[section].first?.modificationDate?.getString() ?? "Другое"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = filteredData[indexPath.section][indexPath.row].text
        cell.contentConfiguration = content
        return cell
    }
}
