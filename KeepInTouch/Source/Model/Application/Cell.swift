//
//  Cell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

struct Cell<T: Equatable>: Equatable {
    var value: T
    var cellType: OneObjectPresentableCell<T>.Type

    init(_ value: T, _ cellType: OneObjectPresentableCell<T>.Type) {
        self.value = value
        self.cellType = cellType
    }

    public static func ==(lhs: Cell<T>, rhs: Cell<T>) -> Bool {
        return lhs.value == rhs.value &&
            lhs.cellType == rhs.cellType
    }
}
