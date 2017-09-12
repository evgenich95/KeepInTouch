//
//  Cell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

struct CollectionCellData<T: Equatable>: Equatable {
    var value: T
    var type: SingleItemCollectionCell<T>.Type

    init(_ value: T, _ type: SingleItemCollectionCell<T>.Type) {
        self.value = value
        self.type = type
    }

    public static func ==(lhs: CollectionCellData<T>, rhs: CollectionCellData<T>) -> Bool {
        return lhs.value == rhs.value &&
            lhs.type == rhs.type
    }
}
