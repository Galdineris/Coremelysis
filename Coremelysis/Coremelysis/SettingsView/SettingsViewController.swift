//
//  SettingsViewController.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 27/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit
import SafariServices

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

    /// Currently selected cell in the `Machine Learning` section.
    private lazy var selectedMachineLearningCell: UITableViewCell = self.settingsCellArr[0][0]

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
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground

        title = "Settings"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch viewModel.selectedModel {
        case .default:
            selectedMachineLearningCell = settingsCellArr[0][0]
            selectedMachineLearningCell.accessoryType = .checkmark
        case .sentimentPolarity:
            selectedMachineLearningCell = settingsCellArr[0][1]
            selectedMachineLearningCell.accessoryType = .checkmark
        case .customModel:
            break
        }
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
            let section = settingsCellArr[indexPath.section]
            if section[indexPath.row] !== selectedMachineLearningCell {
                selectedMachineLearningCell.accessoryType = .none
                section[indexPath.row].accessoryType = .checkmark
                selectedMachineLearningCell = section[indexPath.row]
                switch indexPath.row {
                case 0:
                    viewModel.selectedModel = .default
                case 1:
                    viewModel.selectedModel = .sentimentPolarity
                default:
                    break
                }
            }
        } else {
            switch indexPath.row {
            case 0:
                guard let chosenURL = viewModel.gitHubURL else {
                    return
                }
                openURL(chosenURL)
            case 1:
                guard let chosenURL = viewModel.licenseURL else {
                    return
                }
                openURL(chosenURL)
            default:
                return
            }
        }
    }
}

// - MARK: UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsCellArr.count
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
        return settingsCellArr[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingsCellArr[indexPath.section][indexPath.row]
    }
}

// - MARK: SFSafariController
extension SettingsViewController: SFSafariViewControllerDelegate {
    fileprivate func openURL(_ url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self

        present(safariViewController, animated: true)
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
}
