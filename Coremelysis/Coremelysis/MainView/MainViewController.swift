//
//  MainViewController.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 13/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

/// The representation of the main screen of the app.
final class MainViewController: UIViewController {
    @AutoLayout var infoLabel: UILabel
    @AutoLayout var contentTextField: UITextField
    @AutoLayout var analyzeButton: UIButton
    @AutoLayout var resultLabel: UILabel

    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error: ViewController should not be deserialized.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupLayout()
        setupUI()

        title = "Coremelysis"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        setupInfoLabel()
        setupContentTextField()
        setupAnalyzeButton()
        setupResultLabel()
    }

    private func setupInfoLabel() {
        infoLabel.text = """
        Write bellow what you want the app to analyze.
        The more content you provide, the better the analysis will be.
        """
        infoLabel.font = .preferredFont(forTextStyle: .body)
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .coremelysisAccent
    }

    private func setupContentTextField() {
        contentTextField.placeholder = "Add here the content to be analyzed"
        contentTextField.font = .preferredFont(forTextStyle: .headline)
        contentTextField.textColor = .coremelysisAccent
    }

    private func setupAnalyzeButton() {
        analyzeButton.setTitle("Analyze", for: .normal)
        analyzeButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        analyzeButton.setTitleColor(.coremelysisBackground, for: .normal)
        analyzeButton.addTarget(self, action: #selector(analyze), for: .touchUpInside)
        analyzeButton.backgroundColor = .coremelysisAccent
    }

    private func setupResultLabel() {
        resultLabel.text = ""
        resultLabel.font = .preferredFont(forTextStyle: .headline)
        resultLabel.backgroundColor = .coremelysisPositive
        resultLabel.textColor = .coremelysisBackground
    }

    private func setupLayout() {
        view.addSubview(infoLabel)
        view.addSubview(contentTextField)
        view.addSubview(analyzeButton)
        view.addSubview(resultLabel)

        let safeAreaLayoutGuides = self.view.safeAreaLayoutGuide
        let layoutMarginsGuide = self.view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuides.topAnchor,
                                           constant: LayoutSpec.Spacing.fromNavigation),
            infoLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor),
            infoLabel.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),

            contentTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor,
                                                  constant: LayoutSpec.Spacing.default),
            contentTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor),
            contentTextField.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),

            analyzeButton.topAnchor.constraint(equalTo: contentTextField.bottomAnchor,
                                               constant: LayoutSpec.Spacing.default),
            analyzeButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor),
            analyzeButton.heightAnchor.constraint(equalToConstant: LayoutSpec.Button.height),
            analyzeButton.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor),

            resultLabel.topAnchor.constraint(equalTo: analyzeButton.bottomAnchor,
                                             constant: LayoutSpec.Spacing.default),
            resultLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuides.centerXAnchor)
        ])
    }

    @objc private func analyze() {
        resultLabel.text = viewModel.analyze(contentTextField.text ?? "")
    }
}
