//
//  TableCellData.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

struct TableCellData<T: Equatable>: Equatable {
    var value: T
    var type: SingleItemTableCell<T>.Type

    init(_ value: T, _ type: SingleItemTableCell<T>.Type) {
        self.value = value
        self.type = type
    }

    public static func ==(lhs: TableCellData<T>, rhs: TableCellData<T>) -> Bool {
        return lhs.value == rhs.value &&
            lhs.type == rhs.type
    }
}
