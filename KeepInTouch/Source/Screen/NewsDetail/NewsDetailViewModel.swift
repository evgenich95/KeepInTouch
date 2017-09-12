//
//  NewsDetailViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation

protocol NewsDetailViewModelDelegate: class {

}

class NewsDetailViewModel {

    weak var delegate: NewsDetailViewModelDelegate?

    // MARK: - Properties -
    var title: String {
        return ""
    }

    var url: URL

    init(url: URL) {
        self.url = url
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
