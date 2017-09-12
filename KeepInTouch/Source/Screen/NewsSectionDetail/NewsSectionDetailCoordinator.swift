//
//  NewsSectionDetailCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit

protocol NewsSectionDetailCoordinatorDelegate: class {

}

class NewsSectionDetailCoordinator: Coordinator {

    weak var delegate: NewsSectionDetailCoordinatorDelegate?

    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    // MARK: - Start ViewModel -
    var newsSectionDetailViewModel: NewsSectionDetailViewModel!

    // MARK: - Children ViewModels -
    typealias Data = NewsSectionDetailViewModel.Data
    var sectionedValues: Data

    init(navigationController: UINavigationController, sectionedValues: Data) {
        self.navigationController = navigationController
        self.sectionedValues = sectionedValues
    }

    func start() {
        newsSectionDetailViewModel = NewsSectionDetailViewModel(sectionedValues: sectionedValues)
        newsSectionDetailViewModel.delegate = self

        let viewController = NewsSectionDetailViewController(viewModel: newsSectionDetailViewModel)
        configureNavigationItems(viewController)

        navigationController.pushViewController(viewController, animated: true)
    }

    private func configureNavigationItems(_ viewController: NewsSectionDetailViewController) {

    }
}

extension NewsSectionDetailCoordinator {
    // MARK: - Open children ViewModels functions -
    fileprivate func openDetails(of item: NewsSectionDetailViewModel.Value) {
        removeAllChildren()
        let newsDetailCoordinator = NewsDetailCoordinator(navigationController: navigationController, detailNews: item)
        addChildCoordinator(newsDetailCoordinator)
        startChildren()
    }
}

extension NewsSectionDetailCoordinator: NewsSectionDetailViewModelDelegate {
    func newsSectionDetailViewModelDidOpenDetails(of news: NewsSectionDetailViewModel.Value) {
        openDetails(of: news)
    }
}
