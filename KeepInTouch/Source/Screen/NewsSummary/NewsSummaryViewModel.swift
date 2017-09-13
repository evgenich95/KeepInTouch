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
    func newsSummaryViewModelDidOpenSectionDetails(of section: SectionedValues<NewsSummaryViewModel.Section, NewsSummaryViewModel.Value>)
    func newsSummaryViewModelDidOpenValueDetails(of value: NewsSummaryViewModel.Value)
}
class NewsSummaryViewModel {
    weak var delegate: NewsSummaryViewModelDelegate?

    var title: String {
        return "News Summary"
    }

    let requiredNewsTypes = [NewsType.top7]
//        , NewsType.last24, NewsType.none]

    typealias Section = String
    typealias Value = News

    private typealias Data = SectionedValues<Section, Value>
    typealias CollectionData = SectionedValues<Section, CollectionCellData<Value>>

    private var data = Data() {
        didSet {
            sectionedValues = data
                .removedDuplicates
                .collectionViewData(valueToCellType: { value in
                switch value.type {
                case .top7:
                    return ImageNewsCollectionViewCell.self
                default:
                    return SimpleNewsCollectionViewCell.self
                }
            })
        }
    }
    var sectionedValues = CollectionData() {
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
            }.then(on: background) {[weak self] results -> Void in
                guard let `self` = self else {
                    return
                }

                var data = Data()

                for (index, news) in results.enumerated() {
                    let type = self.requiredNewsTypes[index]
                    news.forEach {
                        $0.type = type
                    }
                    let sortedValues = news.sorted(by: { (n1, n2) -> Bool in
                        n1.pubDate > n2.pubDate
                    })

                    data = data.appending(sectionAndValue: (type.description, sortedValues))
                }

                self.data = data

            }.catch {[weak self] (error) in
                self?.onSignInRequestFailed?(error)
        }
    }

    func viewDetails(of section: Section) {
        if let detailedData = data.sectionsAndValues.first(where: {$0.0 == section}) {
            let sectionedValues = SectionedValues<Section, Value>([detailedData])
            delegate?.newsSummaryViewModelDidOpenSectionDetails(of: sectionedValues)
        }
    }

    func openDetails(of value: Value) {
        delegate?.newsSummaryViewModelDidOpenValueDetails(of: value)
    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    //TODO: Implement
    var dataDidChangeWithoutChanges: EmptyFunction?
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ error: Error) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
