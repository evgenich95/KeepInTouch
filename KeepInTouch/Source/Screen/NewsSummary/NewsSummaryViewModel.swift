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
            printMe(with: ["type = \(type)"])
            switch result {
            case .success(let news):
                self?.data.append(contentsOf: news.flatMap({
                    $0.type = type
                    return $0
                }))
                print("news loaded count = \(news.count)")
            case .failed(let error):
                print("Loading failed\n\(error)")
            }
        }
    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ errorDescription: String) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
