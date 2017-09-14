//
//  AppCoordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var navigationController = UINavigationController()
    var children: [Coordinator] = []

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        setupTheme()
    }

    private func startMainFlow() {
        removeAllCoordinators()
        let mainNavigationController = build(UINavigationController()) {
            $0.navigationBar.isTranslucent = false
        }

        let mainFlowCoordinator = MainFlowCoordinator(navigationController: mainNavigationController)

        add(coordinator: mainFlowCoordinator)

        window.rootViewController = mainNavigationController

        startCoordinators()
    }

    func start() {
        startMainFlow()
        window.makeKeyAndVisible()
    }

    private func setupTheme() {
        UINavigationBar.appearance().barTintColor = .white
    }
}
