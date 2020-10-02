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
        numberOfEntriesLabel.font = .preferredFont(forTextStyle: .largeTitle)
        numberOfEntriesLabel.numberOfLines = 0
        numberOfEntriesLabel.textColor = .coremelysisAccent
        numberOfEntriesLabel.textAlignment = .center

        view.addSubview(numberOfEntriesLabel)
    }

    private func setupEntriesLabels() {
        positiveEntriesLabel.backgroundColor = .coremelysisPositive
        negativeEntriesLabel.backgroundColor = .coremelysisNegative
        neutralEntriesLabel.backgroundColor = .coremelysisNeutral

        positiveEntriesLabel.font = .preferredFont(forTextStyle: .title1)
        negativeEntriesLabel.font = .preferredFont(forTextStyle: .title1)
        neutralEntriesLabel.font = .preferredFont(forTextStyle: .title1)

        positiveEntriesLabel.textColor = .coremelysisBackground
        negativeEntriesLabel.textColor = .coremelysisBackground
        neutralEntriesLabel.textColor = .coremelysisBackground

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

            positiveEntriesLabel.topAnchor.constraint(equalTo: numberOfEntriesLabel.bottomAnchor),
            positiveEntriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            positiveEntriesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                         constant: -DesignSystem.Spacing.default),
            positiveEntriesLabel.trailingAnchor.constraint(equalTo: neutralEntriesLabel.leadingAnchor),

            neutralEntriesLabel.topAnchor.constraint(equalTo: numberOfEntriesLabel.bottomAnchor),
            neutralEntriesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            neutralEntriesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                constant: -DesignSystem.Spacing.default),
            neutralEntriesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.34),

            negativeEntriesLabel.topAnchor.constraint(equalTo: numberOfEntriesLabel.bottomAnchor),
            negativeEntriesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            negativeEntriesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                         constant: -DesignSystem.Spacing.default ),
            negativeEntriesLabel.leadingAnchor.constraint(equalTo: neutralEntriesLabel.trailingAnchor)
        ])
    }

}
