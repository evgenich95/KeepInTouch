//
//  NewsSectionDetailViewController.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation
import UIKit

class NewsSectionDetailViewController: ViewController {

    @IBOutlet weak var tableView: TableView!
    var tableViewDelegate: NewsSectionDetailTableViewDelegate!

    var viewModel: NewsSectionDetailViewModel

    var dataSource: NewsSectionDetailViewModel.TableData {
        return viewModel.tableData
    }

    init(viewModel: NewsSectionDetailViewModel) {
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
        configureTableView()
    }

    private func configureTableView() {
        tableViewDelegate = NewsSectionDetailTableViewDelegate(tableView: tableView, data: dataSource)
    }

    fileprivate func updateView() {
        tableViewDelegate.reloadData(by: dataSource)
    }

}

// MARK: - ViewModel Binding -
extension NewsSectionDetailViewController {

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
