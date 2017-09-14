//
//  UIView + set UIViewController.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func set(_ viewController: UIViewController) {
        addSubview(viewController.view)
        viewController.view.frame = CGRect(origin: CGPoint.zero, size: frame.size)
    }
}
