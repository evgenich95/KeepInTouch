//
//  NewsSummaryCollectionLayout.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

protocol NewsSummaryCollectionLayoutDelegate: class {
    func newsSummaryCollectionLayoutDidSelectItem(at indexPaht: IndexPath)
}

class NewsSummaryCollectionLayout: NSObject, UICollectionViewDelegateFlowLayout {

    weak var delegate: NewsSummaryCollectionLayoutDelegate?

    var collectionView: UICollectionView

    let mixSpaceBetweenCells: CGFloat = 0.25
    let mixSpaceBetweenSections: CGFloat = 0.25

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

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let maxWidth = collectionView.bounds.width

        let width = (indexPath.section == 0) ?  maxWidth : maxWidth / 2

        return CGSize(width: width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return mixSpaceBetweenSections
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return mixSpaceBetweenCells
        return 0

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.newsSummaryCollectionLayoutDidSelectItem(at: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}
