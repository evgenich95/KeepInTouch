//
//  NewsSectionDetailViewControllerStateMachine.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class NewsSectionDetailViewControllerStateMachine {

    typealias State = ListState<NewsSectionDetailViewModel.TableData>
    var state: State = .loading

    var ownerFrame: CGRect {
        return owner?.view.frame ?? CGRect()
    }

    var usingView: [UIView] {
        guard let owner = owner else {
            return []
        }
        return [
            owner.tableView,
            owner.errorView,
            owner.noDataView
        ]
    }

    weak var owner: NewsSectionDetailViewController?

    init(owner: NewsSectionDetailViewController) {
        self.owner = owner
    }

    func `switch`(to state: State) {
        resetUsingView()
        switch state {
        case .error(let error):
            changeStateToError(error)
        case .loaded(let values):
            changeStateToLoaded(values)
        case .noData:
            changeStateToNoData()
        case .loading:
            changeStateToLoading()
        }
    }

    private func resetUsingView() {
        usingView.forEach {
            $0.isHidden = true
        }
        owner?.hideLoadingView()
    }

    private func changeStateToLoaded(_ values: NewsSectionDetailViewModel.TableData) {
        guard let owner = owner else {
            return
        }
        owner.tableView.isHidden = false
        owner.tableViewDelegate.reloadData(by: values)
        owner.refreshControl.endRefreshing()
    }

    private func changeStateToError(_ error: Error) {
        guard let owner = owner else {
            return
        }

        owner.errorView.isHidden = false
        owner.errorView.frame = ownerFrame
        owner.errorView.center = CGPoint(x: ownerFrame.width / 2,
                                         y: ownerFrame.height / 2)
        owner.errorView.set(error: error)
    }

    private func changeStateToNoData() {
        guard let owner = owner else {
            return
        }

        owner.noDataView.isHidden = false
        owner.noDataView.frame = ownerFrame
        owner.noDataView.center = CGPoint(x: ownerFrame.width / 2,
                                          y: ownerFrame.height / 2)
        owner.noDataView.set(text: "We have not data to display right now.\nCheck later")
    }

    private func changeStateToLoading() {
        owner?.showLoadingView()
    }
}
