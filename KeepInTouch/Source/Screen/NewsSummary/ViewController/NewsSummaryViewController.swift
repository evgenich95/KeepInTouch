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

    var collectionDataSource: NewsSummaryCollectionDataSource!
    var collectionLayout: NewsSummaryCollectionLayout!

    @IBOutlet weak var newsCollectionView: CollectionView!

    var dataSource: NewsSummaryViewModel.CollectionData {
        return viewModel.sectionedValues
    }

    init(viewModel: NewsSummaryViewModel) {
        self.viewModel = viewModel
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
//        viewModel.loadRequiredData()
    }

    internal override func setupView() {
        super.setupView()
        setupCollectionView()

    }

    private func setupCollectionView() {
        printMe()
        collectionDataSource = NewsSummaryCollectionDataSource(collectionView: newsCollectionView, data: dataSource)
        collectionDataSource.delegate = self
        collectionLayout = NewsSummaryCollectionLayout(collectionView: newsCollectionView)
        collectionLayout.delegate = self
    }

    fileprivate func updateView() {
        printMe()
        collectionDataSource.reloadData(by: dataSource)
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

