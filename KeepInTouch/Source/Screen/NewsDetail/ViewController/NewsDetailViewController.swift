//
//  NewsDetailViewController.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class NewsDetailViewController: UIViewController {

    let viewModel: NewsDetailViewModel
    let safariViewController: SFSafariViewController

    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        self.safariViewController = SFSafariViewController(url: viewModel.url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        setupSafariController()
    }

    private func setupSafariController() {
        addChildViewController(safariViewController)
        view.set(safariViewController)
    }
}
