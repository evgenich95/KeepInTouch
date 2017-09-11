//
//  CollectionView.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

enum SupplementaryViewType {
    case header
    case footer

    var keyValue: String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
        case .footer:
            return UICollectionElementKindSectionFooter
        }
    }
}

class CollectionView: UICollectionView {
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }

    func register(_ cellClassName: String) {
        let nibName = cellClassName
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibName)
    }

    func register<T: UICollectionReusableView>(_ view: T.Type, for type: SupplementaryViewType) {
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: nil)

        register(nib, forSupplementaryViewOfKind: type.keyValue, withReuseIdentifier: nibName)
    }

    func view<T: UICollectionReusableView>(ofType: T.Type, assignedAs type: SupplementaryViewType, for indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)

        guard let view = dequeueReusableSupplementaryView(ofKind: type.keyValue, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("'\(identifier)' is not registered as \(type)")
        }
        return view
    }


    func updatedCell<T, P>(ofType: T.Type, by object: P, at indexPath: IndexPath) -> T where T: OneObjectPresentableCell<P> {
        let cell = getRegisteredCell(ofType: ofType, at: indexPath)
        cell.updateUI(by: object)
        return cell
    }

    func getRegisteredCell<T>(ofType: T.Type, at indexPath: IndexPath) -> T {
        let cellIdentifier = String(describing: ofType)
        guard let cell =  dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? T else {
            fatalError("\(String(describing: T.self)) is not registered by CollectionView.register(_ cell:) method")
        }
        return cell
    }
}
