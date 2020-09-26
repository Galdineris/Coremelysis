//
//  HistorySummaryViewController.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 21/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

/// The representation of the History screen summary
final class HistorySummaryViewController: UIViewController {

    // - MARK: Properties
    @AutoLayout private var numberOfEntriesLabel: UILabel
    @AutoLayout private var positiveEntriesLabel: UILabel
    @AutoLayout private var negativeEntriesLabel: UILabel
    @AutoLayout private var neutralEntriesLabel: UILabel

    /// The ViewModel bound to this type.
    private var viewModel: HistorySummaryViewModel

    // - MARK: Init
    init(viewModel: HistorySummaryViewModel = HistorySummaryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // - MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumberOfEntriesLabel()
        setupEntriesLabels()
        layoutConstraints()
    }

    // - MARK: Update
    func update(with viewModel: HistorySummaryViewModel) {
        self.viewModel = viewModel
        self.numberOfEntriesLabel.text = viewModel.numberOfEntries
        self.positiveEntriesLabel.text = viewModel.numberOfPositiveEntries
        self.negativeEntriesLabel.text = viewModel.numberOfNegativeEntries
        self.neutralEntriesLabel.text = viewModel.numberOfNeutralEntries
    }

    // - MARK: Layout
    private func setupNumberOfEntriesLabel() {
        numberOfEntriesLabel.text = viewModel.numberOfEntries
        numberOfEntriesLabel.font = .preferredFont(forTextStyle: .title1)
        numberOfEntriesLabel.numberOfLines = 0
        numberOfEntriesLabel.textColor = .coremelysisAccent
        numberOfEntriesLabel.textAlignment = .center

        view.addSubview(numberOfEntriesLabel)
    }

    private func setupEntriesLabels() {
        positiveEntriesLabel.textColor = .coremelysisPositive
        negativeEntriesLabel.textColor = .coremelysisNegative
        neutralEntriesLabel.textColor = .coremelysisNeutral

        positiveEntriesLabel.font = .preferredFont(forTextStyle: .headline)
        negativeEntriesLabel.font = .preferredFont(forTextStyle: .headline)
        neutralEntriesLabel.font = .preferredFont(forTextStyle: .headline)

        positiveEntriesLabel.text = viewModel.numberOfPositiveEntries
        negativeEntriesLabel.text = viewModel.numberOfNegativeEntries
        neutralEntriesLabel.text = viewModel.numberOfNeutralEntries

        positiveEntriesLabel.textAlignment = .center
        negativeEntriesLabel.textAlignment = .center
        neutralEntriesLabel.textAlignment = .center

        view.addSubview(positiveEntriesLabel)
        view.addSubview(negativeEntriesLabel)
        view.addSubview(neutralEntriesLabel)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            numberOfEntriesLabel.topAnchor.constraint(equalTo: view.topAnchor),
            numberOfEntriesLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            numberOfEntriesLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            numberOfEntriesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            positiveEntriesLabel.topAnchor.constraint(equalTo: numberOfEntriesLabel.bottomAnchor,
                                                      constant: DesignSystem.Spacing.default),
            positiveEntriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            positiveEntriesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            positiveEntriesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),

            negativeEntriesLabel.topAnchor.constraint(equalTo: numberOfEntriesLabel.bottomAnchor,
                                                      constant: DesignSystem.Spacing.default),
            negativeEntriesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            negativeEntriesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            negativeEntriesLabel.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                        multiplier: 0.3),

            neutralEntriesLabel.topAnchor.constraint(equalTo: numberOfEntriesLabel.bottomAnchor,
                                                     constant: DesignSystem.Spacing.default),
            neutralEntriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            neutralEntriesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            neutralEntriesLabel.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                       multiplier: 0.3)
        ])
    }

}
