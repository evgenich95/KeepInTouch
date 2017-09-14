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

    // MARK: - UI -
    var errorView: LabelView = LabelView()
    var noDataView: LabelView = LabelView()

    @IBOutlet weak var newsCollectionView: CollectionView!

    lazy var refreshControl: UIRefreshControl = {
        let refresh =  UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to update")
        refresh.addTarget(self,
                          action: #selector(refreshTableData(refreshControl:)),
                          for: UIControlEvents.valueChanged)
        return refresh
    }()

    // MARK: - Class variables -
    var collectionDataSource: NewsSummaryCollectionDataSource!
    private var collectionDelegate: NewsSummaryCollectionDelegate!

    private var dataSource: NewsSummaryViewModel.CollectionData {
        return viewModel.sectionedValues
    }

    // MARK: - Init -
    fileprivate let viewModel: NewsSummaryViewModel
    fileprivate var stateMachine: NewsSummaryStateMachine!

    init(viewModel: NewsSummaryViewModel) {
        self.viewModel = viewModel
        defer {
            stateMachine = NewsSummaryStateMachine(owner: self)
        }
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadRequiredData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        newsCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindToViewModel()
    }

    internal override func setupView() {
        super.setupView()
        setupCollectionView()
        setupErrorView()
        setupNoDataView()
        setupNavigationItems()
        stateMachine.switch(to: .loading)
    }

    private func setupCollectionView() {
        newsCollectionView.addSubview(refreshControl)
        collectionDataSource = NewsSummaryCollectionDataSource(collectionView: newsCollectionView, data: dataSource)
        collectionDelegate = NewsSummaryCollectionDelegate(collectionView: newsCollectionView)

        collectionDataSource.onViewSectionAction = {[weak self] section in
            self?.viewModel.viewDetails(for: section)
        }
        collectionDelegate.onDidSelectItem = {[weak self] indexPath in
            guard let `self` = self else {
                return
            }
            let value = self.dataSource.value(for: indexPath).value
            self.viewModel.openDetails(for: value)
        }
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
        stateMachine.switch(to: dataSource.isEmpty ? .noData : .loaded(dataSource))
    }

    @objc private func refreshTableData(refreshControl: UIRefreshControl) {
        viewModel.updateData()
    }
}

// MARK: - Reactions -
extension NewsSummaryViewController {
    fileprivate func bindToViewModel() {
        viewModel.onDataDidNotChange = {[weak self] in
            DispatchQueue.main.async {
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
                self?.stateMachine.switch(to: .error(error))
            }
        }
    }
}
