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
        fatalError("Fatal Error: ViewController should not be deserialized.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupLayout()

        title = "Coremelysis"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground

        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.distribution = .equalCentering

        infoLabel.text = "Information"
        infoLabel.font = UIFont.preferredFont(forTextStyle: .title1)

        userTextField.placeholder = "Type Here"
        userTextField.font = UIFont.preferredFont(forTextStyle: .headline)

        analyzeButton.backgroundColor = .systemBlue
        analyzeButton.addTarget(self, action: #selector(analyze), for: .touchUpInside)
        analyzeButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        analyzeButton.setTitle("Analyze", for: .normal)
        analyzeButton.tintColor = .systemGray6
        analyzeButton.layer.cornerRadius = 50 / 2
        analyzeButton.clipsToBounds = true

        resultLabel.text = "not infered"
        resultLabel.font = .preferredFont(forTextStyle: .headline)

        mainStack.addArrangedSubview(infoLabel)
        mainStack.addArrangedSubview(userTextField)
        mainStack.addArrangedSubview(analyzeButton)
        mainStack.addArrangedSubview(resultLabel)

        self.view.addSubview(mainStack)

        let guides = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mainStack.heightAnchor.constraint(equalTo: guides.heightAnchor, multiplier: 0.6),
            mainStack.widthAnchor.constraint(equalTo: guides.widthAnchor, multiplier: 0.8),
            mainStack.centerYAnchor.constraint(equalTo: guides.centerYAnchor),
            mainStack.centerXAnchor.constraint(equalTo: guides.centerXAnchor),

            analyzeButton.widthAnchor.constraint(equalToConstant: 150),
            analyzeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func analyze() {
        resultLabel.text = viewModel.analyze(userTextField.text ?? "")
    }
}
