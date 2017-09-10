//
//  Coordinator.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: class, AnyObject {
    var childCoordinators: [Coordinator] { get set }

    func start()
    func addChildCoordinator(_ coordinator: Coordinator)
    func removeChildCoordinator(_ coordinator: Coordinator)
    func startChildren()
    func removeAllChildren()
    //TODO: Проверить на необходимость
    var navigationController: UINavigationController {get set}

    func hideCurrentScreen()
}

extension Coordinator {
    func hideCurrentScreen() {
        DispatchQueue.main.async {[weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.navigationController.dismiss(animated: true, completion: nil)
        }
    }

    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childCoordinators.index(where: {$0 === coordinator}) {
            childCoordinators.remove(at: index)
        }
    }

    func startChildren() {
        childCoordinators.forEach { $0.start() }
    }

    func removeAllChildren() {
        childCoordinators.removeAll()
    }
}
