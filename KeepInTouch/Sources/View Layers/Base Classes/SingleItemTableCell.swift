//
//  SingleItemTableCell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class SingleItemTableCell<T>: UITableViewCell {
    func updateUI(with object: T) {
        fatalError("Not overriden updateUI method in \(String(describing: self)) class")
    }
}
