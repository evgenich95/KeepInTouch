//
//  NewsSummaryCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit

class NewsSummaryCoordinator: Coordinator {

    var children: [Coordinator] = []

    var navigationController: UINavigationController

    var newsSummaryViewModel: NewsSummaryViewModel!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        newsSummaryViewModel = NewsSummaryViewModel()
        newsSummaryViewModel.delegate = self

        let viewController = NewsSummaryViewController(viewModel: newsSummaryViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension NewsSummaryCoordinator {
    // MARK: - Open children ViewModels functions -
    fileprivate func viewSectioned(data: NewsSectionDetailCoordinator.Data) {
        removeAllCoordinators()
        let newsSectionDetailCoordinator =  NewsSectionDetailCoordinator(navigationController: navigationController, sectionedValues: data)
        add(coordinator: newsSectionDetailCoordinator)
        startCoordinators()
    }

    fileprivate func viewDetails(for value: NewsSummaryViewModel.Value) {
        removeAllCoordinators()
        let newsDetailCoordinator = NewsDetailCoordinator(navigationController: navigationController, detailNews: value)
        add(coordinator: newsDetailCoordinator)
        startCoordinators()
    }
}

extension NewsSummaryCoordinator: NewsSummaryViewModelDelegate {
    func newsSummaryViewModel(_ newsSummaryViewModel: NewsSummaryViewModel, didOpenValueDetailsFor value: NewsSummaryViewModel.Value) {
        viewDetails(for: value)
    }

    func newsSummaryViewModel(_ newsSummaryViewModel: NewsSummaryViewModel, didOpenSectionDetailsFor section: SectionedValues<NewsSummaryViewModel.Section, NewsSummaryViewModel.Value>) {
        viewSectioned(data: section)
    }
}
