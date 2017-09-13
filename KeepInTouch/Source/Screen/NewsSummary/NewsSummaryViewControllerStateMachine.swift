//
//  NewsSummaryViewControllerStateMachine.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class NewsSummaryViewControllerStateMachine {

    typealias State = ListState<NewsSummaryViewModel.CollectionData>
    var state: State = .noData

    var ownerFrame: CGRect {
        return owner.view.frame
    }

    var usingView: [UIView] {
        return [
            owner.newsCollectionView,
            owner.errorView,
            owner.noDataView
        ]
    }

    var owner: NewsSummaryViewController

    init(owner: NewsSummaryViewController) {
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
        owner.hideLoadingView()
    }

    private func changeStateToLoaded(_ values: NewsSummaryViewModel.CollectionData) {
        owner.newsCollectionView.isHidden = false
        owner.collectionDataSource.reloadData(by: values)
        owner.refreshControl.endRefreshing()
    }

    private func changeStateToError(_ error: Error) {
        owner.errorView.isHidden = false
        owner.errorView.frame = ownerFrame
        owner.errorView.center = CGPoint(x: ownerFrame.width / 2,
                                         y: ownerFrame.height / 2)
        owner.errorView.set(error: error)
    }

    private func changeStateToNoData() {
        owner.noDataView.isHidden = false
        owner.noDataView.frame = ownerFrame
        owner.noDataView.center = CGPoint(x: ownerFrame.width / 2,
                                         y: ownerFrame.height / 2)
        owner.noDataView.set(text: "We have not data to display right now.\nCheck later")
    }

    private func changeStateToLoading() {
        owner.showLoadingView()
    }

}
