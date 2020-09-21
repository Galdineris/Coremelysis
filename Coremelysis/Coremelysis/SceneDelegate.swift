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
        let settingsVC = SettingsViewController(viewModel: SettingsViewModel())
        let historyVC = HistoryViewController(viewModel: HistoryViewModel(), summaryViewController: HistorySummaryViewController())
        let tabBarController = CoremelysisTabBarController(mainViewController: mainVC,
                                                           settingsViewController: settingsVC,
                                                           historyViewController: historyVC)
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
