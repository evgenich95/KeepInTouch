//
//  NewsSummaryCollectionDelegate.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class NewsSummaryCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var onDidSelectItem: ((_ at: IndexPath) -> Void)?
    private let collectionView: UICollectionView

    private let minSpaceBetweenCells: CGFloat = 0
    private let minSpaceBetweenSections: CGFloat = 0

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        setup()
    }

    private func setup() {
        collectionView.delegate = self
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
        return minSpaceBetweenSections
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minSpaceBetweenCells
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onDidSelectItem?(indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

}
