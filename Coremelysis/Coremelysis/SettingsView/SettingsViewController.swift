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
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var settingsCellArr: [[UITableViewCell]] = {
        let coreMLCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        coreMLCell.textLabel?.text = "CoreML"
        coreMLCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        coreMLCell.tintColor = .coremelysisAccent
        coreMLCell.detailTextLabel?.text = "Sentiment analysis using CoreML(NLP) default model."

        let sentimentPolariyCell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        sentimentPolariyCell.textLabel?.text = "Sentiment Polarity model"
        sentimentPolariyCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        sentimentPolariyCell.tintColor = .coremelysisAccent
        /// Add the correct source and from which python library the model was converted from.
        sentimentPolariyCell.detailTextLabel?.text = "CoreML model converted from Python by [SOURCE]"

        let machineLearningSection = [coreMLCell, sentimentPolariyCell]

        let gitHubCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        gitHubCell.textLabel?.text = "GitHub"
        gitHubCell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        gitHubCell.accessoryType = .disclosureIndicator
        let licenses = UITableViewCell(style: .default, reuseIdentifier: nil)
        licenses.textLabel?.text = "Licenses"
        licenses.textLabel?.font = .preferredFont(forTextStyle: .headline)
        licenses.accessoryType = .disclosureIndicator

        let aboutSection = [gitHubCell, licenses]

        return [machineLearningSection, aboutSection]
    }()

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

        setupTableView()
        setupConstraints()

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

        view.addSubview(settingsTableView)
    }
}

// - MARK: UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if settingsCellArr[indexPath.section][indexPath.row].accessoryType == .checkmark {
                settingsCellArr[indexPath.section][indexPath.row].accessoryType = .none
            } else {
                settingsCellArr[indexPath.section][indexPath.row].accessoryType = .checkmark
            }
        }
    }
}

// - MARK: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Machine Learning"
        case 1:
            return "About"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingsCellArr[indexPath.section][indexPath.row]
    }
}
