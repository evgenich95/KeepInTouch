//
//  NewsSummaryCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit

protocol NewsSummaryCoordinatorDelegate: class {

}

class NewsSummaryCoordinator: Coordinator {

    weak var delegate: NewsSummaryCoordinatorDelegate?

    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    // MARK: - Start ViewModel -
    var newsSummaryViewModel: NewsSummaryViewModel!

    // MARK: - Children ViewModels -

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        newsSummaryViewModel = NewsSummaryViewModel()
        newsSummaryViewModel.delegate = self

        let viewController = NewsSummaryViewController(viewModel: newsSummaryViewModel)
        configureNavigationItems(viewController)

        navigationController.pushViewController(viewController, animated: true)
    }

    private func configureNavigationItems(_ viewController: NewsSummaryViewController) {

    }
}

extension NewsSummaryCoordinator {
    // MARK: - Open children ViewModels functions -
    fileprivate func viewSectioned(data: NewsSectionDetailCoordinator.Data) {
        removeAllChildren()
        let newsSectionDetailCoordinator =  NewsSectionDetailCoordinator(navigationController: navigationController, sectionedValues: data)
        addChildCoordinator(newsSectionDetailCoordinator)
        startChildren()
    }

    fileprivate func viewDetails(of value: NewsSummaryViewModel.Value) {
        removeAllChildren()
        let newsDetailCoordinator = NewsDetailCoordinator(navigationController: navigationController, detailNews: value)
        addChildCoordinator(newsDetailCoordinator)
        startChildren()
    }
}

extension NewsSummaryCoordinator: NewsSummaryViewModelDelegate {
    func newsSummaryViewModelDidOpenValueDetails(of value: NewsSummaryViewModel.Value) {
        viewDetails(of: value)
    }
    func newsSummaryViewModelDidOpenSectionDetails(of section: NewsSectionDetailCoordinator.Data) {
        viewSectioned(data: section)
    }
}
