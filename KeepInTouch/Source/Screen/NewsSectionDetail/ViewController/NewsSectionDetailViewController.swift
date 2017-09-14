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

    // MARK: - UI -
    @IBOutlet weak var tableView: TableView!
    var errorView: LabelView = LabelView()
    var noDataView: LabelView = LabelView()

    lazy var refreshControl: UIRefreshControl = {
        let refresh =  UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to update")
        refresh.addTarget(self,
                          action: #selector(refreshTableData(refreshControl:)),
                          for: UIControlEvents.valueChanged)
        return refresh
    }()

    // MARK: - Class variables -
    var tableViewDelegate: NewsSectionDetailTableViewDataSource!

    private var dataSource: NewsSectionDetailViewModel.TableData {
        return viewModel.tableData
    }
    // MARK: - Init -
    fileprivate var stateMachinge: NewsSectionDetailStateMachine!
    fileprivate let viewModel: NewsSectionDetailViewModel

    init(viewModel: NewsSectionDetailViewModel) {
        self.viewModel = viewModel
        defer {
            stateMachinge = NewsSectionDetailStateMachine(owner: self)
        }

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindToViewModel()
        stateMachinge.switch(to: dataSource.isEmpty ? .loading : .loaded(dataSource))
    }

    internal override func setupView() {
        super.setupView()
        configureTableView()
        setupErrorView()
        setupNoDataView()
        setupNavigationItems()
    }

    private func configureTableView() {
        tableViewDelegate = NewsSectionDetailTableViewDataSource(tableView: tableView, data: dataSource)
        tableViewDelegate.delegate = self
        tableView.addSubview(refreshControl)
    }

    private func setupErrorView() {
        view.addSubview(errorView)
    }

    private func setupNoDataView() {
        view.addSubview(noDataView)
    }

    private func setupNavigationItems() {
        title = viewModel.title
    }

    fileprivate func updateView() {
        stateMachinge.switch(to: dataSource.isEmpty ? .noData : .loaded(dataSource))
    }

    @objc private func refreshTableData(refreshControl: UIRefreshControl) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.viewModel.updateData()
        }
    }
}

extension NewsSectionDetailViewController {

    fileprivate func bindToViewModel() {
        viewModel.onDataDidNotChange = {[weak self] in
            DispatchQueue.main.async {
                self?.hideLoadingView()
                self?.refreshControl.endRefreshing()
            }
        }

        viewModel.onDataDidChange = {[weak self] in
            DispatchQueue.main.async {
                self?.updateView()
            }
        }

        viewModel.onDataRequestFailed = {[weak self] error in
            DispatchQueue.main.async {
                self?.stateMachinge.switch(to: .error(error))
            }
        }
    }
}

extension NewsSectionDetailViewController: NewsSectionDetailTableViewDataSourceDelegate {
    func newsSectionDetailTableViewDataSourceDidSelect(item: NewsSectionDetailViewModel.Value) {
        viewModel.openDetail(of: item)
    }
}
