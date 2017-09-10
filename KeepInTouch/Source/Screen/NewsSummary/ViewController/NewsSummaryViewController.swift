//
//  NewsSummaryViewController.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit

class NewsSummaryViewController: ViewController {

    var viewModel: NewsSummaryViewModel

    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    init(viewModel: NewsSummaryViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadRequiredData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindToViewModel()
    }

    internal override func setupView() {
        super.setupView()

    }

    fileprivate func updateView() {

    }

}

// MARK: - ViewModel Binding -
extension NewsSummaryViewController {

    fileprivate func bindToViewModel() {
        viewModel.dataDidChange = {[weak self] in
            DispatchQueue.main.async {
                self?.updateView()
            }
        }

        viewModel.onSignInRequestStart = {[weak self] in
            DispatchQueue.main.async {
//                self?.showLoadingView(nil, view: self?.navigationController?.view)
            }
        }

        viewModel.onSignInRequestEnd = {[weak self] in
            DispatchQueue.main.async {
//                self?.hideLoadingView()
            }
        }

        viewModel.onSignInRequestFailed = {[weak self] (errorDescription) in
            DispatchQueue.main.async {
                self?.showNotificationAlert(withTitle: "Error", message: "Something gone wrong. \(errorDescription)")
            }
        }
    }
}
