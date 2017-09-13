//
//  UIViewController+ProgressLoading.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit
import CustomHUD

extension UIViewController {
    func showLoadingView(_ text: String? = nil, view: UIView? = nil) {
        CustomHUD.instance.showLoading(at: view ?? self.view)
    }

    func hideLoadingView() {
        CustomHUD.instance.hideLoading()
    }
}
