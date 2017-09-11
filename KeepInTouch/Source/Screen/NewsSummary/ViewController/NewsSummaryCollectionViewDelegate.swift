//
//  NewsSummaryCollectionViewDelegate.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class NewsSummaryCollectionViewDelegate: NSObject, UICollectionViewDataSource {
    var registeredCells = [String]()

    typealias Data = NewsSummaryViewModel.Data
    private var collectionView: CollectionView
    private var data: Data

    init(collectionView: CollectionView, data: Data) {
        self.collectionView = collectionView
        self.data = data
        defer {
            setup()
        }
        super.init()
    }

    private func setup() {
        collectionView.dataSource = self
        registerCells()
    }

    func reloadData(by updates: Data) {
        data = updates
        registerCells()
        collectionView.reloadData()
    }

    private func registerCells() {
        let usingCellTypesStr = data.sectionsAndValues
            .flatMap {$0.1}
            .flatMap {$0.cellType}
            .flatMap {String(describing: $0)}
            .filter {!registeredCells.contains($0)}

        let unicCells = Set(usingCellTypesStr)

        unicCells.forEach {
            registeredCells.append($0)
            collectionView.register($0)
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        printMe(with: ["data.sections.count = \(data.sections.count)"])
        return data.sections.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return data.sections[section].isEmpty ? 0 : 4
    }

    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = data.value(for: indexPath)
        return self.collectionView.updatedCell(ofType: cell.cellType, by: cell.value, at: indexPath)
    }
}
