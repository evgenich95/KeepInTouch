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

    // MARK: - Class variables -
    var collectionDataSource: NewsSummaryCollectionDataSource!
    var collectionLayout: NewsSummaryCollectionLayout!

    var dataSource: NewsSummaryViewModel.CollectionData {
        return viewModel.sectionedValues
    }

    // MARK: - Init -
    var viewModel: NewsSummaryViewModel
    var stateMachinge: NewsSummaryViewControllerStateMachine!

    init(viewModel: NewsSummaryViewModel) {
        self.viewModel = viewModel
        defer {
            stateMachinge = NewsSummaryViewControllerStateMachine(owner: self)
        }
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        background.async {[weak self] in
            self?.viewModel.loadRequiredData()
        }
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
        stateMachinge.switch(to: .loading)
    }

    private func setupCollectionView() {
        collectionDataSource = NewsSummaryCollectionDataSource(collectionView: newsCollectionView, data: dataSource)
        collectionLayout = NewsSummaryCollectionLayout(collectionView: newsCollectionView)

        collectionDataSource.delegate = self
        collectionLayout.delegate = self
    }

    private func setupErrorView() {
        view.addSubview(errorView)
    }

    private func setupNoDataView() {
        view.addSubview(noDataView)
    }

    fileprivate func updateView() {
        stateMachinge.switch(to: dataSource.isEmpty ? .noData : .loaded(dataSource))
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
                self?.showLoadingView()
            }
        }

        viewModel.onSignInRequestEnd = {[weak self] in
            DispatchQueue.main.async {
                self?.hideLoadingView()
            }
        }

        viewModel.onSignInRequestFailed = {[weak self] error in
            DispatchQueue.main.async {
                self?.stateMachinge.switch(to: .error(error))
            }
        }
    }
}

extension NewsSummaryViewController: NewsSummaryCollectionDataSourceDelegate {
    func newsSummaryCollectionDataSourceDidView(section: NewsSummaryViewModel.Section) {
        viewModel.viewDetails(of: section)
    }
}

extension NewsSummaryViewController: NewsSummaryCollectionLayoutDelegate {
    func newsSummaryCollectionLayoutDidSelectItem(at indexPaht: IndexPath) {
        let value = dataSource.value(for: indexPaht).value
        viewModel.openDetails(of: value)
    }
}
