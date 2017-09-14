//
//  CustomHUD.swift
//  CustomHUD
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

public class CustomHUD {
    public static  var instance: CustomHUD = CustomHUD()

    internal let activityIndicator = ActivityIndicator()

    public func showLoading(at view: UIView, animated: Bool = true) {
        DispatchQueue.main.async {
            self.activityIndicator.show(at: view, animated: true)
        }
    }

    public func hideLoading(animated: Bool = true) {
        DispatchQueue.main.async {
            self.activityIndicator.hide(animated: false)
        }
    }
}
