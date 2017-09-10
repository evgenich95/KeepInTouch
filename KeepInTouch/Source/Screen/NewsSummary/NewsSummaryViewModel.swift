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

    func loadRequiredData() {

    }

    // MARK: - Binding properties -
    typealias EmptyFunction = (() -> Void)
    var dataDidChange: EmptyFunction?
    var onSignInRequestFailed: ((_ errorDescription: String) -> Void)?
    var onSignInRequestStart: EmptyFunction?
    var onSignInRequestEnd: EmptyFunction?
}
