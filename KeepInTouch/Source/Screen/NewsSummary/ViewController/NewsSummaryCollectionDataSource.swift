//
//  NewsSummaryCollectionDataSource.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

fileprivate let maxItemsInSection = 4
class NewsSummaryCollectionDataSource: NSObject {

    var onViewSectionAction: ((_ section: NewsSummaryViewModel.Section) -> Void)?

    var registeredCells = [String]()
    let header = NewsSummaryHeader.self

    typealias Data = NewsSummaryViewModel.CollectionData
    fileprivate let collectionView: CollectionView
    fileprivate var data: Data

    init(collectionView: CollectionView, data: Data) {
        self.collectionView = collectionView
        self.data = data
        super.init()
        setup()
    }

    private func setup() {
        collectionView.dataSource = self
        registerCellsIfNeed()
    }

    func reloadData(by updates: Data) {
        data = updates
        registerCellsIfNeed()
        collectionView.reloadData()
        collectionView.register(header, for: .header)
    }

    private func registerCellsIfNeed() {
        let unregisteredCellTypes: [String] = data.sectionsAndValues
            .flatMap {$0.1}
            .flatMap {$0.type}
            .flatMap {String(describing: $0)}
            .filter {!registeredCells.contains($0)}

        let uniqueCells = Set(unregisteredCellTypes)

        uniqueCells.forEach {
            registeredCells.append($0)
            collectionView.register($0)
        }
    }
}

extension NewsSummaryCollectionDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.sections.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.sections[section].isEmpty ? 0 : maxItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = data.value(for: indexPath)
        return self.collectionView.makeCell(ofType: cell.type, with: cell.value, at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView = self.collectionView.view(ofType: header, assignedAs: .header, for: indexPath)
        let name = data.sections[indexPath.section]
        headerView.updateUI(headerName: name, viewAction: viewSection(for: indexPath))

        return headerView
    }

    private func viewSection(for indexPath: IndexPath) -> EmptyFunction {
        let section = data.sections[indexPath.section]
        return {
            self.onViewSectionAction?(section)
        }
    }
}
