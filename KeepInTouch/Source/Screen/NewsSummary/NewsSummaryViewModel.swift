//
//  NewsSummaryViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import PromiseKit
import LentaSDK

protocol NewsSummaryViewModelDelegate: class {
    func newsSummaryViewModel(_ newsSummaryViewModel: NewsSummaryViewModel, didOpenValueDetailsFor value: NewsSummaryViewModel.Value)

    func newsSummaryViewModel(_ newsSummaryViewModel: NewsSummaryViewModel, didOpenSectionDetailsFor section: SectionedValues<NewsSummaryViewModel.Section, NewsSummaryViewModel.Value>)
}

class NewsSummaryViewModel {
    weak var delegate: NewsSummaryViewModelDelegate?

    var title: String {
        return "News Summary"
    }

    private let requiredNewsTypes = [NewsType.top7, NewsType.last24, NewsType.none]

    typealias Section = String
    typealias Value = News

    private typealias Data = SectionedValues<Section, Value>
    typealias CollectionData = SectionedValues<Section, CollectionCellData<Value>>

    private var data = Data() {
        didSet {
            sectionedValues = data
                .withoutDuplicates
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
                onDataDidNotChange?()
                return
            }

            self.onDataDidChange?()
        }
    }

    func viewDetails(for section: Section) {
        if let detailedData = data.sectionsAndValues.first(where: {$0.0 == section}) {
            let sectionedValues = SectionedValues<Section, Value>([detailedData])
            delegate?.newsSummaryViewModel(self, didOpenSectionDetailsFor: sectionedValues)
        }
    }

    func openDetails(for value: Value) {
        delegate?.newsSummaryViewModel(self, didOpenValueDetailsFor: value)
    }

    func updateData() {
        loadRequiredData()
    }

    // MARK: - Web Layer -
    func loadRequiredData() {
        let background = DispatchQueue.global(qos: .userInitiated)
        WebService.loadNews(with: requiredNewsTypes)
            .then(on: background) {[weak self] typedNews in
                self?.save(typedNews: typedNews)
            }.catch {[weak self] (error) in
                self?.onDataRequestFailed?(error)
        }
    }

    private func save(typedNews: [(NewsType, [News])]) {
        var data = Data()
        let sorted = sortedByDate(typedNews)
        sorted.forEach {
            let newSection = ($0.0.description, $0.1)
            data = data.appending(sectionAndValue: newSection)
        }
        self.data = data
    }

    private func sortedByDate(_ typedNews: [(NewsType, [News])]) -> [(NewsType, [News])] {
        var result = typedNews
        for (index, cortege) in typedNews.enumerated() {
            let sortedNews = cortege.1.sorted { $0.pubDate > $1.pubDate}
            let updatedCortege = (cortege.0, sortedNews)
            result[index] = updatedCortege
        }
        return result
    }

    // MARK: - Reactions -
    var onDataDidNotChange: EmptyFunction?
    var onDataDidChange: EmptyFunction?
    var onDataRequestFailed: ((_ error: Error) -> Void)?
}
