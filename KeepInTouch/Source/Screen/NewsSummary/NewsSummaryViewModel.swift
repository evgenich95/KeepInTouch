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

}

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

class NewsSummaryViewModel {

    weak var delegate: NewsSummaryViewModelDelegate?

    // MARK: - Properties -
    var title: String {
        return "News Summary"
    }

    let requiredNewsTypes = [NewsType.top7, NewsType.last24, NewsType.none]

    typealias Section = String
    typealias Value = News
    typealias Data = SectionedValues<Section, Cell<Value>>

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

    var sectionedValues = Data()

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
                for (index, news) in results.enumerated() {
                    let type = self.requiredNewsTypes[index]
                    news.forEach {
                        $0.type = type
                    }
                    //                    self.sectionedValues.append((type.description, news))
                    printMe(with: ["Load \(news.count) at \(type.description)"])
                    let cells = news.flatMap {self.cell(for: $0)}
                    self.sectionedValues = self.sectionedValues.appending(sectionAndValue: (type.description, cells))

                }
                printMe(with: ["Sections is loaded"])
                self.dataDidChange?()
            }.catch { (error) in
                //TODO: Show user alert for users
                print("error = \(error)")
        }
    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ errorDescription: String) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
