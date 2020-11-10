//
//  MainViewController.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 13/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit
import CoremelysisML

/// The representation of the Main screen of the app.
final class MainViewController: UIViewController {
// - MARK: Properties

    /// The label containing a brief description of the app.
    @AutoLayout var infoLabel: UILabel
    /// The user's input to be analyzed.
    @AutoLayout var contentTextField: UITextField
    /// The button responsible for calling the analysis.
    @AutoLayout var analyzeButton: UIButton
    /// The label containing the result of the analysis.
    @AutoLayout var resultLabel: UILabel

    /// The ViewModel of this type.
    private let viewModel: MainViewModel

// - MARK: Init

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error: ViewController should not be deserialized.")
    }

// - MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupLayout()
        setupUI()

        title = "Coremelysis"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

// - MARK: UI updates

    /// Updates the result label with the result of an analysis.
    private func updateResultLabel(using text: String) {
        let sentiment = viewModel.analyze(text)
        switch sentiment {
        case .awful, .bad:
            resultLabel.text = sentiment.rawValue
            resultLabel.backgroundColor = .coremelysisNegative
        case .neutral, .notFound:
            resultLabel.text = sentiment.rawValue
            resultLabel.backgroundColor = .coremelysisNeutral
        case .good, .great:
            resultLabel.text = sentiment.rawValue
            resultLabel.backgroundColor = .coremelysisPositive
        }
    }

// - MARK: Layout

    /// Bundles all necessary UI related functions to setup the initial interface.
    private func setupUI() {
        setupInfoLabel()
        setupContentTextField()
        setupAnalyzeButton()
        setupResultLabel()
    }

    /// Configures the label containing a brief description of the app.
    private func setupInfoLabel() {
        infoLabel.text = """
        Write bellow what you want the app to analyze.
        The more content you provide, the better the analysis will be.
        """
        infoLabel.font = .preferredFont(forTextStyle: .body)
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .coremelysisAccent
    }

    /// Configures the UITextField responsible for the user's input.
    private func setupContentTextField() {
        contentTextField.placeholder = "Add here the content to be analyzed"
        contentTextField.font = .preferredFont(forTextStyle: .headline)
        contentTextField.textColor = .coremelysisAccent
    }

    /// Configures the UIButton responsible for calling the analysis.
    private func setupAnalyzeButton() {
        analyzeButton.setTitle("Analyze", for: .normal)
        analyzeButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        analyzeButton.setTitleColor(.coremelysisBackground, for: .normal)
        analyzeButton.addTarget(self, action: #selector(analyze), for: .touchUpInside)
        analyzeButton.backgroundColor = .coremelysisAccent
    }

    /// Configures the label containing the result of the analysis.
    private func setupResultLabel() {
        resultLabel.text = ""
        resultLabel.font = .preferredFont(forTextStyle: .headline)
        resultLabel.backgroundColor = .clear
        resultLabel.textColor = .coremelysisBackground
        resultLabel.textAlignment = .center
    }

    /// Configures all the necessary constraints and layouts all the views.
    private func setupLayout() {
        view.addSubview(infoLabel)
        view.addSubview(contentTextField)
        view.addSubview(analyzeButton)
        view.addSubview(resultLabel)

        let safeAreaLayoutGuides = self.view.safeAreaLayoutGuide
        let layoutMarginsGuide = self.view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuides.topAnchor,
                                           constant: DesignSystem.Spacing.fromNavigation),
            infoLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor),
            infoLabel.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),

            contentTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor,
                                                  constant: DesignSystem.Spacing.default),
            contentTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor),
            contentTextField.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),

            analyzeButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor,
                                               constant: -(DesignSystem.Spacing.default)),
            analyzeButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor),
            analyzeButton.heightAnchor.constraint(equalToConstant: DesignSystem.Button.height),
            analyzeButton.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),

            resultLabel.topAnchor.constraint(equalTo: contentTextField.bottomAnchor,
                                             constant: DesignSystem.Spacing.default),
            resultLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor),
            resultLabel.heightAnchor.constraint(equalToConstant: DesignSystem.Button.height),
            resultLabel.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor)
        ])
    }

    /// Requests an analysis.
    @objc private func analyze() {
        if let content = contentTextField.text {
            updateResultLabel(using: content)
        }
    }
}
