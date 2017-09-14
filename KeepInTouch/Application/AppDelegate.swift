//
//  AppDelegate.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let keyWindow = UIWindow(frame: UIScreen.main.bounds)

        window = keyWindow
        appCoordinator = AppCoordinator(window: keyWindow)
        appCoordinator?.start()

        return true
    }
}
