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
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController {get set}

    func start()
    func add(coordinator: Coordinator)
    func remove(coordinator: Coordinator)
    func startCoordinators()
    func removeAllCoordinators()
}

extension Coordinator {
    func add(coordinator: Coordinator) {
        children.append(coordinator)
    }

    func remove(coordinator: Coordinator) {
        if let index = children.index(where: {$0 === coordinator}) {
            children.remove(at: index)
        }
    }

    func startCoordinators() {
        children.forEach { $0.start() }
    }

    func removeAllCoordinators() {
        children.removeAll()
    }
}
