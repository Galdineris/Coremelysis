//
//  SceneDelegate.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 13/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let mainVC = MainViewController(viewModel: MainViewModel(mlManager: MLManager()))
        let mainNavController = UINavigationController(rootViewController: mainVC)
        let settingsVC = SettingsViewController(viewModel: SettingsViewModel())
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
        let historyVC = HistoryViewController(viewModel: HistoryViewModel())
        let historyNavController = UINavigationController(rootViewController: historyVC)
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        tabBarController.viewControllers = [historyNavController, mainNavController, settingsNavController]
        tabBarController.selectedIndex = 1
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = tabBarController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

}
