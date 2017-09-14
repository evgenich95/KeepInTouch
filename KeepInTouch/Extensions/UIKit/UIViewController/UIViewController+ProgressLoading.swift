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
    func showLoadingView() {
        CustomHUD.instance.showLoading(at: self.navigationController?.view ?? self.view)
    }

    func hideLoadingView() {
        CustomHUD.instance.hideLoading()
    }
}
