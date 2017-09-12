//
//  NewsSectionDetailTableViewDelegate.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class NewsSectionDetailTableViewDelegate: NSObject {
    typealias Data = NewsSectionDetailViewModel.TableData
    var tableView: TableView
    var data: Data

    var registeredCells = [String]()

    init(tableView: TableView, data: Data) {
        self.tableView = tableView
        self.data = data
        defer {
            setup()
        }

        super.init()
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
        let usingCellTypesStr = data.sectionsAndValues
            .flatMap {$0.1}
            .flatMap {$0.type}
            .flatMap {String(describing: $0)}
            .filter {!registeredCells.contains($0)}

        let unicCells = Set(usingCellTypesStr)

        unicCells.forEach {
            registeredCells.append($0)
            tableView.register(cellClassName: $0)
        }
    }
}

extension NewsSectionDetailTableViewDelegate: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sectionsAndValues[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = data.value(for: indexPath)
        return self.tableView.updatedCell(ofType: cell.type, by: cell.value, at: indexPath)
    }
}
