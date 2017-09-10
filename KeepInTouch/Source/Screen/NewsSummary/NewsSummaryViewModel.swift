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

class NewsSummaryViewModel {

    weak var delegate: NewsSummaryViewModelDelegate?

    // MARK: - Properties -
    var title: String {
        return "News Summary"
    }

    init() {}

    let requiredNewsTypes = [NewsType.top7, NewsType.last24, NewsType.none]

    typealias Section = String
    typealias Value = News
    typealias Data = SectionedValues<Section, Value>

    var sectionedValues = Data()

    //MARK: - Web Layer -

    func loadRequiredData() {
        let promises = requiredNewsTypes.map { WebService.loadPromiseNews(with: $0) }

        firstly {
            when(fulfilled: promises)
        }.then {[weak self] results -> Void in
            guard let `self` = self else {
                return
            }
            for (index, news) in results.enumerated() {
                let type = self.requiredNewsTypes[index]
                self.sectionedValues = self.sectionedValues.appending(sectionAndValue: (type.description, news))
            }
        }.catch { (error) in
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
