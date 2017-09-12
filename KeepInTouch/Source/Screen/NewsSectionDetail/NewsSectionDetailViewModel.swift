//
//  NewsSectionDetailViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation

protocol NewsSectionDetailViewModelDelegate: class {

}

class NewsSectionDetailViewModel {

    weak var delegate: NewsSectionDetailViewModelDelegate?

    // MARK: - Properties -
    var title: String {
        return ""
    }
    typealias Section = String
    typealias Value = News
    typealias Data = SectionedValues<Section, Value>
    typealias TableData = SectionedValues<Section, TableCellData<Value>>

    var tableData = TableData()
    var sectionedValues = Data() {
        didSet {
            var data = TableData()
            sectionedValues.sectionsAndValues.forEach { section, newsArray in
                let cells = newsArray.flatMap {
                    TableCellData($0, cellType(for: $0))
                }
                data = data.appending(sectionAndValue: (section, cells))
            }
            tableData = data
        }
    }

    func cellType(for item: Value) -> SingleItemTableCell<Value>.Type {
        return NewsSectionDetailTableViewCell.self
    }

    init(sectionedValues: Data) {
        self.sectionedValues = sectionedValues
    }

    func loadRequiredData() {

    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ errorDescription: String) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
