//
//  NewsSectionDetailViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import LentaSDK

protocol NewsSectionDetailViewModelDelegate: class {
    func newsSectionDetailViewModelDidOpenDetails(of news: NewsSectionDetailViewModel.Value)
}

class NewsSectionDetailViewModel {

    weak var delegate: NewsSectionDetailViewModelDelegate?

    // MARK: - Properties -
    var title: String {
        return sectionedValues.sections.first ?? ""
    }
    let background = DispatchQueue.global(qos: .userInitiated)

    typealias Section = String
    typealias Value = News

    typealias Data = SectionedValues<Section, Value>
    typealias TableData = SectionedValues<Section, TableCellData<Value>>

    var tableData = TableData() {
        didSet {
            if oldValue == tableData {
                onDataDidNotChange?()
                return
            }
            onDataDidChange?()
        }
    }
    private var sectionedValues = Data() {
        didSet {
            tableData = sectionedValues
                .withoutDuplicates
                .tableViewData(valueToCellType: {_ in
                    return NewsSectionDetailTableViewCell.self
                })
        }
    }

    init(sectionedValues: Data) {
        defer {
            background.async {[weak self] in
                self?.sectionedValues = sectionedValues
            }
        }
    }

    func openDetail(of news: Value) {
        delegate?.newsSectionDetailViewModelDidOpenDetails(of: news)
    }

    func updateData() {
        let newsTypes = Array(Set<NewsType>(
            sectionedValues.sectionsAndValues
                .flatMap { $0.1 }
                .flatMap { $0.type }
        ))

        WebService.loadNews(with: newsTypes)
            .then(on: background) {[weak self] typedNews in
                self?.save(typedNews: typedNews)
            }.catch {[weak self] error in
                self?.onDataRequestFailed?(error)
        }
    }

    private func save(typedNews: [(NewsType, [News])]) {
        var sectionedValues = Data()
        let sorted = sortedByDate(typedNews)
        sorted.forEach {
            let newSection = ($0.0.description, $0.1)
            sectionedValues = sectionedValues.appending(sectionAndValue: newSection)
        }
        self.sectionedValues = sectionedValues
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
