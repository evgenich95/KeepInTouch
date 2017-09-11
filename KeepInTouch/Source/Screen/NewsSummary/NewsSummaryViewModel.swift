//
//  NewsSummaryViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import PromiseKit

protocol NewsSummaryViewModelDelegate: class {
    func newsSummaryViewModelDidOpenDetails(of section: NewsSummaryViewModel.Section)
}
class NewsSummaryViewModel {
    weak var delegate: NewsSummaryViewModelDelegate?

    var title: String {
        return "News Summary"
    }

    let requiredNewsTypes = [NewsType.top7, NewsType.last24, NewsType.none]

    typealias Section = String
    typealias Value = News
    typealias Data = SectionedValues<Section, Cell<Value>>

    var sectionedValues = Data() {
        didSet {
            if oldValue == sectionedValues {
                dataDidChangeWithoutChanges?()
                return
            }
            self.dataDidChange?()
        }
    }

    init() {}

    // MARK: - Web Layer -
    func loadRequiredData() {
        let promises = requiredNewsTypes.map { WebService.loadNews(with: $0) }

        firstly {
            when(fulfilled: promises)
            }.then {[weak self] results -> Void in
                guard let `self` = self else {
                    return
                }
                var sectionedValues = Data()
                for (index, news) in results.enumerated() {
                    let type = self.requiredNewsTypes[index]
                    news.forEach {
                        $0.type = type
                    }
                    let cells = news.flatMap {self.cell(for: $0)}
                    let newSection = (type.description, cells)
                    sectionedValues = sectionedValues.appending(sectionAndValue: newSection)
                }
                self.sectionedValues = sectionedValues

            }.catch { (error) in
                //TODO: Show user alert for users
                print("error = \(error)")
        }
    }

    func cellType(for item: Value) -> OneObjectPresentableCell<Value>.Type {
        switch item.type {
        case .top7:
            return ImageNewsCollectionViewCell.self
        default:
            return SimpleNewsCollectionViewCell.self
        }
    }

    func cell(for item: Value) -> Cell<Value> {
        return Cell(item, cellType(for: item))
    }

    func viewDetails(of section: Section) {
        delegate?.newsSummaryViewModelDidOpenDetails(of: section)
    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    //TODO: Implement
    var dataDidChangeWithoutChanges: EmptyFunction?
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ errorDescription: String) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
