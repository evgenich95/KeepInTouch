//
//  TableView.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class TableView: UITableView {
    func register(cellType: UITableViewCell.Type) {
        let nibName = String(describing: cellType)
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: nibName)
    }

    func register(cellClassName: String) {
        let nib = UINib(nibName: cellClassName, bundle: nil)
        register(nib, forCellReuseIdentifier: cellClassName)
    }

    func makeCell<Cell, Value>(ofType: Cell.Type, with object: Value, at indexPath: IndexPath) -> Cell where Cell: SingleItemTableCell<Value> {
        let cell = getRegisteredCell(ofType: ofType, at: indexPath)
        cell.updateUI(with: object)
        return cell
    }

    func getRegisteredCell<T>(ofType: T.Type, at indexPath: IndexPath) -> T {
        let cellIdentifier = String(describing: ofType)

        guard let cell =  dequeueReusableCell(withIdentifier: cellIdentifier) as? T else {
            fatalError("\(String(describing: T.self)) is not registered by TableView.register(_ cell:) method")
        }
        return cell
    }
}
