//
//  NewsSectionDetailCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit

class NewsSectionDetailCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    var newsSectionDetailViewModel: NewsSectionDetailViewModel!
    var rootViewController: NewsSectionDetailViewController

    typealias Data = NewsSectionDetailViewModel.Data
    var sectionedValues: Data

    init(navigationController: UINavigationController, sectionedValues: Data) {
        self.navigationController = navigationController
        self.sectionedValues = sectionedValues

        newsSectionDetailViewModel = NewsSectionDetailViewModel(sectionedValues: sectionedValues)

        rootViewController = NewsSectionDetailViewController(viewModel: newsSectionDetailViewModel)
        newsSectionDetailViewModel.delegate = self
    }

    func start() {
        navigationController.pushViewController(rootViewController, animated: true)
    }
}

extension NewsSectionDetailCoordinator {
    // MARK: - Open children ViewModels functions -
    fileprivate func openDetails(for item: NewsSectionDetailViewModel.Value) {
        removeAllCoordinators()
        let newsDetailCoordinator = NewsDetailCoordinator(navigationController: navigationController, detailNews: item)
        add(coordinator: newsDetailCoordinator)
        startCoordinators()
    }
}

extension NewsSectionDetailCoordinator: NewsSectionDetailViewModelDelegate {
    func newsSectionDetailViewModelDidOpenDetails(of news: NewsSectionDetailViewModel.Value) {
        openDetails(for: news)
    }
}
