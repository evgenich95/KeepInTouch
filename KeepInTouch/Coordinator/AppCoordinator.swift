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

    var childCoordinators: [Coordinator] = []

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        setupTheme()
    }

    func startMainFlow() {
        removeAllChildren()
        let mainNavigationController = make(UINavigationController()) {
            $0.navigationBar.isTranslucent = false
        }

        let mainFlowCoordinator = MainFlowCoordinator(navigationController: mainNavigationController)

        addChildCoordinator(mainFlowCoordinator)

        window.rootViewController = mainNavigationController

        startChildren()
    }

    func start() {
        startMainFlow()
        window.makeKeyAndVisible()
    }

    func setupTheme() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .white
    }
}
