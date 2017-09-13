//
//  MainFlowCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class MainFlowCoordinator: Coordinator {
    var navigationController = UINavigationController()

    var children: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        removeAllCoordinators()
        let newsSummaryCoordinator = NewsSummaryCoordinator(navigationController: navigationController)
        add(coordinator: newsSummaryCoordinator)
        newsSummaryCoordinator.start()
    }
}
