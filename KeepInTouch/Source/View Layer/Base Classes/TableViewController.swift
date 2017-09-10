//
//  TableViewController.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit
//TODO: Delete it after

protocol ViewModel {}

class TableViewController<VM: ViewModel>: UITableViewController {

    var viewModel: VM!

    class func parentScreenName() -> String? {
        return nil
    }

    internal func setupView() {
        tableView.tableFooterView = UIView()
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
    }

    class func initFromStoryboard(with viewModel: VM) -> Self {
        let vc =  initStoryboardControllerTemplate(type: self)
        vc.viewModel = viewModel
        return vc
    }

    private class func initStoryboardControllerTemplate<T>(type: T.Type) -> T {
        let storyboardName = parentScreenName() ?? String(describing: T.self)
        let screenName = String(describing: T.self)
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: screenName) as! T
    }
}
