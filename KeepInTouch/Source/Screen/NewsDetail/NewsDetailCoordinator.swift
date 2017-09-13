//
//  NewsDetailCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit
import LentaSDK

class NewsDetailCoordinator: Coordinator {

    var children: [Coordinator] = []

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
        let viewController = NewsDetailViewController(viewModel: newsDetailViewModel)

        navigationController.present(viewController, animated: true, completion: nil)
    }
}
