//
//  OneObjectRepresentableCell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class OneObjectPresentableCell<T>: UICollectionViewCell {
    func updateUI(by object: T) {
        fatalError("Not overriden updateUI method in \(String(describing: self)) class")
    }
}
