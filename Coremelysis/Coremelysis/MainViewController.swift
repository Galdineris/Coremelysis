//
//  MainViewController.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 13/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    @AutoLayout var infoLabel: UILabel
    @AutoLayout var userTextField: UITextField
    @AutoLayout var analyzeButton: UIButton
    @AutoLayout var resultLabel: UILabel
    @AutoLayout var mainStack: UIStackView

    private let viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error: ViewController should not be initialized from Storyboard.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupLayout()
    }

    private func setupLayout() {
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.alignment = .center

        infoLabel.text = "Information"
        userTextField.placeholder = "Type Here"
        analyzeButton.backgroundColor = .systemBlue
        analyzeButton.addTarget(self, action: #selector(analyze), for: .touchUpInside)
        resultLabel.text = "not infered"

        mainStack.addArrangedSubview(infoLabel)
        mainStack.addArrangedSubview(userTextField)
        mainStack.addArrangedSubview(analyzeButton)
        mainStack.addArrangedSubview(resultLabel)

        self.view.addSubview(mainStack)

        let guides = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: guides.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: guides.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: guides.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: guides.trailingAnchor)
        ])
    }

    @objc private func analyze() {
        resultLabel.text = viewModel.analyze(userTextField.text ?? "")
    }
}
