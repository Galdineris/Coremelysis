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

    private lazy var inputAlert: UIAlertController = {
        let alert = UIAlertController(title: "Download Custom Model",
                                      message: "Type or paste the URL to the mlmodel file bellow",
                                      preferredStyle: .alert)
        alert.addTextField { (field) in
            field.keyboardType = .URL
            field.autocorrectionType = .no
        }
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
            guard let url = alert.textFields?.first?.text else { return }
            self?.viewModel.fetchModel(at: url)
            self?.changeSelectedCell(to: self?.settingsCellArr[0][2] ?? UITableViewCell())
        }
        alert.addAction(dismissAction)
        alert.addAction(okAction)
        return alert
    }()

    private let modelCell: (String, String?) -> UITableViewCell = { (title, subtitle) in
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = title
        cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        cell.detailTextLabel?.text = subtitle ?? ""
        cell.tintColor = .coremelysisAccent
        return cell
    }

    private let webLinkCell: (String) -> UITableViewCell = { (title) in
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = title
        cell.textLabel?.font = .preferredFont(forTextStyle: .headline)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    private lazy var settingsCellArr: [[UITableViewCell]] = {
        let coreMLCell = modelCell("CoreML", "Sentiment analysis using CoreML(NLP) default model.")
        let sentimentPolariyCell = modelCell("Sentiment Polarity", "Sentiment Analysis model converted by Vadym Markov")
        let customModelCell = modelCell("Custom Model", nil)
        let machineLearningSection = [coreMLCell, sentimentPolariyCell, customModelCell]

        let gitHubCell = webLinkCell("Github")
        let licensesCell = webLinkCell("Licenses")
        let aboutSection = [gitHubCell, licensesCell]

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
            changeSelectedCell(to: settingsCellArr[0][0])
        case .sentimentPolarity:
            changeSelectedCell(to: settingsCellArr[0][1])
        case .customModel:
            changeSelectedCell(to: settingsCellArr[0][2])
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
            let cell = settingsCellArr[indexPath.section][indexPath.row]
            if cell !== selectedMachineLearningCell {
                switch indexPath.row {
                case 0:
                    viewModel.selectedModel = .default
                    changeSelectedCell(to: cell)
                case 1:
                    viewModel.selectedModel = .sentimentPolarity
                    changeSelectedCell(to: cell)
                default:
                    self.present(inputAlert, animated: true, completion: nil)
                    guard viewModel.selectedModel == .customModel else { return }
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

    private func changeSelectedCell(to cell: UITableViewCell) {
            selectedMachineLearningCell.accessoryType = .none
            selectedMachineLearningCell = cell
            cell.accessoryType = .checkmark
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
