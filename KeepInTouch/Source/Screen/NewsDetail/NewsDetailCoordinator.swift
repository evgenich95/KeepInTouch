//
//  NewsDetailCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit

protocol NewsDetailCoordinatorDelegate: class {

}

class NewsDetailCoordinator: Coordinator {

    weak var delegate: NewsDetailCoordinatorDelegate?

    var childCoordinators: [Coordinator] = []

    // MARK: - Start ViewModel -
    var newsDetailViewModel: NewsDetailViewModel!

    var navigationController: UINavigationController
    var detailNews: News

    init(navigationController: UINavigationController, detailNews: News) {
        self.navigationController = navigationController
        self.detailNews = detailNews
    }

    func start() {
        guard let url = URL(string: detailNews.link) else {
            return
        }
        newsDetailViewModel = NewsDetailViewModel(url: url)
        newsDetailViewModel.delegate = self

        let viewController = NewsDetailViewController(viewModel: newsDetailViewModel)
        configureNavigationItems(viewController)

        navigationController.present(viewController, animated: true, completion: nil)
    }

    private func configureNavigationItems(_ viewController: NewsDetailViewController) {

    }
}

extension NewsDetailCoordinator {
    // MARK: - Open children ViewModels functions -
}

extension NewsDetailCoordinator: NewsDetailViewModelDelegate {

}
