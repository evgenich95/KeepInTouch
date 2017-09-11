//
//  NewsSummaryCollectionLayoutDelegate.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class NewsSummaryCollectionLayoutDelegate: NSObject, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView

    let mixSpaceBetweenCells: CGFloat = 0.5
    let mixSpaceBetweenSections: CGFloat = 0.5

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        defer {
            setup()
        }

        super.init()
    }

    private func setup() {
        collectionView.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth = collectionView.bounds.width

        let width = (indexPath.section == 0) ?  maxWidth : maxWidth / 2

        return CGSize(width: width - mixSpaceBetweenCells, height: 50.0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return mixSpaceBetweenSections
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return mixSpaceBetweenCells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30.0)
    }

}
