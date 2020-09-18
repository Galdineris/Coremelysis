//
//  SettingsViewController.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 27/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

/// The representation of the Settings screen of the app.
final class SettingsViewController: UIViewController {
// - MARK: Properties

    /// The available settings displayed in a UITableView format.
    @AutoLayout private var settingsTableView: UITableView

    /// The ViewModel of this type.
    private let viewModel: SettingsViewModel

// - MARK: Init
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error: ViewController should not be deserialized.")
    }

// - MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupConstraints()
        setupTableView()

        title = "Settings"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

// - MARK: Layout
    /// Layouts constraints.
    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            settingsTableView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            settingsTableView.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            settingsTableView.widthAnchor.constraint(equalTo: guide.widthAnchor),
            settingsTableView.heightAnchor.constraint(equalTo: guide.heightAnchor)
        ])
    }

    /// Configures the UITableView used in this screen.
    private func setupTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self

        settingsTableView.backgroundColor = .systemFill

        settingsTableView.isScrollEnabled = false

        settingsTableView.tableFooterView = UIView()

        view.addSubview(settingsTableView)
    }
}

// - MARK: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {

}

// - MARK: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Primeira"
        case 1:
            return "Segunda"
        case 2:
            return "Terceira"
        default:
            return "ZERO"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 3
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "Teste"
        return cell
    }
}
