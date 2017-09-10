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
    func register<T: UITableViewCell>(_ cell: T.Type) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)

        register(nib, forCellReuseIdentifier: nibName)
    }

    func updatedCell<T, P>(ofType: T.Type, by object: P, at indexPath: IndexPath) -> T where T: OneObjectPresentableCell<P> {
        let cell = getRegisteredCell(ofType: ofType, at: indexPath)
        cell.updateUI(by: object)
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
