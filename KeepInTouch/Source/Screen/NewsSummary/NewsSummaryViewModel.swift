//
//  NewsSummaryViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation

protocol NewsSummaryViewModelDelegate: class {

}

class NewsSummaryViewModel {

    weak var delegate: NewsSummaryViewModelDelegate?

    // MARK: - Properties -
    var title: String {
        return ""
    }

    init() {

    }

    typealias Section = String
    typealias Value = News
    typealias Data = SectionedValues<Section, Value>

    var sectionedValues = Data()

    var sections = [String: [News]]() {
        didSet {

        }
    }

    func handleRawData() {
        sectionedValues = SectionedValues<Section, Value>(dictionary: sections, sortSections: {
            let order = [NewsType.top7, NewsType.last24, NewsType.none]
                .flatMap{$0.description}
            return order.index(of: $0) ?? 0 < order.index(of: $1) ?? 0
        }) { (n1, n2) in
            //TODO: Change on the Date comparing
            n1.link == n2.link
        }

    }

    var data = [News]()

    //MARK: - Web Layer -

    func loadRequiredData() {
        [NewsType.top7, NewsType.last24, NewsType.none].forEach {
            loadNews($0)
        }
    }

    private func loadNews(_ type: NewsType) {
        WebService.loadNews(with: type, completion: completion(for: type))
    }

    func completion(for type: NewsType) -> WebService.Completion<[News]> {
        return {[weak self] result in
            switch result {
            case .success(let news):
                self?.sections[type.description] = news
                self?.data.append(contentsOf: news.flatMap({
                    $0.type = type
                    return $0
                }))
                print("news loaded count = \(news.count)")
            case .failed(let error):
                print("Loading failed\n\(error)")
            }
            printMe(with: ["sections = \(self?.sections)"])

        }

    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ errorDescription: String) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
