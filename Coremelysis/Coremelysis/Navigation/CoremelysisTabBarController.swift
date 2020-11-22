//
//  CoremelysisTabBarController.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 18/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

/// The custom UITabBarController responsible for navigation.
final class CoremelysisTabBarController: UITabBarController {
// - MARK: Properties
    /// The main screen embeded in a UINavigationController.
    private let mainScreen: UINavigationController
    /// The settings screen embeded in a UINavigationController.
    private let settingsScreen: UINavigationController
    /// The history screen embeded in a UINavigationController.
    private let historyScreen: UINavigationController

// - MARK: Init
    /// Initializes an instance of this type.
    /// - Parameter mainViewController: The main screen UIViewController.
    /// - Parameter settingsViewController: The settings screen UIViewController.
    /// - Parameter historyViewController: The history screen UIViewControlelr.
    init(mainViewController: MainViewController,
         settingsViewController: SettingsViewController,
         historyViewController: HistoryViewController) {

        self.mainScreen = UINavigationController(rootViewController: mainViewController)
        self.settingsScreen = UINavigationController(rootViewController: settingsViewController)
        self.historyScreen = UINavigationController(rootViewController: historyViewController)

        super.init(nibName: nil, bundle: nil)

        self.viewControllers = [historyScreen, mainScreen, settingsScreen]
        self.selectedIndex = 1
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// - MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .coremelysisAccent
        configureIcons()
    }

// - MARK: Layout

    /// Configures each item's image and selected images using SF Symbols.
    private func configureIcons() {
        mainScreen.tabBarItem.image = UIImage(systemName: "house")
        mainScreen.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        mainScreen.title = "Coremelysis"

        settingsScreen.tabBarItem.image = UIImage(systemName: "gear")
        settingsScreen.tabBarItem.selectedImage = UIImage(systemName: "gear.fill")
        settingsScreen.title = "Settings"

        historyScreen.tabBarItem.image = UIImage(systemName: "clock")
        historyScreen.tabBarItem.image = UIImage(systemName: "clock.fill")
        historyScreen.title = "History"
    }

}
