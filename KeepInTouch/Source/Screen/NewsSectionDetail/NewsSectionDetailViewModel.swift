//
//  NewsSectionDetailViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation

protocol NewsSectionDetailViewModelDelegate: class {
    func newsSectionDetailViewModelDidOpenDetails(of news: NewsSectionDetailViewModel.Value)
}

class NewsSectionDetailViewModel {

    weak var delegate: NewsSectionDetailViewModelDelegate?

    // MARK: - Properties -
    var title: String {
        return sectionedValues.sections.first ?? ""
    }

    typealias Section = String
    typealias Value = News

    typealias Data = SectionedValues<Section, Value>
    typealias TableData = SectionedValues<Section, TableCellData<Value>>

    var tableData = TableData() {
        didSet {
            if oldValue == tableData {
                dataDidChangeWithoutChanges?()
            }
            dataDidChange?()
        }
    }
    private var sectionedValues = Data() {
        didSet {
            tableData = sectionedValues.tableViewData(valueToCellType: {_ in
                return NewsSectionDetailTableViewCell.self
            })
        }
    }

    init(sectionedValues: Data) {
        defer {
            self.sectionedValues = sectionedValues
        }
    }

    func openDetail(of news: Value) {
        delegate?.newsSectionDetailViewModelDidOpenDetails(of: news)
    }

    func loadRequiredData() {

    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    var dataDidChangeWithoutChanges: EmptyFunction?
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ errorDescription: String) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
