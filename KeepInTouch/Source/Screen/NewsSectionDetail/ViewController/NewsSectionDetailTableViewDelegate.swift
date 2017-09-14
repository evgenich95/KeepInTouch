//
//  NewsSectionDetailTableViewDataSource.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

protocol NewsSectionDetailTableViewDataSourceDelegate: class {
    func newsSectionDetailTableViewDataSourceDidSelect(item: NewsSectionDetailViewModel.Value)
}

class NewsSectionDetailTableViewDataSource: NSObject {
    weak var delegate: NewsSectionDetailTableViewDataSourceDelegate?

    typealias Data = NewsSectionDetailViewModel.TableData
    fileprivate let tableView: TableView
    fileprivate var data: Data

    private var registeredCells = [String]()

    init(tableView: TableView, data: Data) {
        self.tableView = tableView
        self.data = data
        super.init()
        setup()
    }

    private func setup() {
        configureTableView()
        registerCellsIfNeed()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }

    func reloadData(by updates: Data) {
        data = updates
        registerCellsIfNeed()
        tableView.reloadData()
    }

    private func registerCellsIfNeed() {
        let unregisteredCellTypes: [String] = data.sectionsAndValues
            .flatMap {$0.1}
            .flatMap {$0.type}
            .flatMap {String(describing: $0)}
            .filter {!registeredCells.contains($0)}

        let uniqueCells = Set(unregisteredCellTypes)

        uniqueCells.forEach {
            registeredCells.append($0)
            tableView.register(cellClassName: $0)
        }
    }
}

extension NewsSectionDetailTableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sectionsAndValues[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = data.value(for: indexPath)
        return self.tableView.makeCell(ofType: cell.type, with: cell.value, at: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellValue = data.value(for: indexPath).value
        delegate?.newsSectionDetailTableViewDataSourceDidSelect(item: cellValue)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
