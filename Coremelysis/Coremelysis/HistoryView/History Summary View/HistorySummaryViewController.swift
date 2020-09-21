//
//  HistorySummaryViewController.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 21/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

final class HistorySummaryViewController: UIViewController {

    @AutoLayout private var numberOfEntriesLabel: UILabel
    @AutoLayout private var positiveEntriesView: UIView
    @AutoLayout private var negativeEntriesView: UIView
    @AutoLayout private var neutralEntriesView: UIView

    private var viewModel: HistorySummaryViewModel

    init(viewModel: HistorySummaryViewModel = HistorySummaryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNumberOfEntriesLabel()
        setupEntriesViews()
        layoutConstraints()
    }

    func update(with viewModel: HistorySummaryViewModel) {
        self.viewModel = viewModel
    }

    private func setupNumberOfEntriesLabel() {
        numberOfEntriesLabel.text = viewModel.numberOfEntries
        numberOfEntriesLabel.font = .preferredFont(forTextStyle: .headline)
        numberOfEntriesLabel.numberOfLines = 0
        numberOfEntriesLabel.textColor = .coremelysisAccent

        view.addSubview(numberOfEntriesLabel)
    }

    private func setupEntriesViews() {
        positiveEntriesView.backgroundColor = .coremelysisPositive
        negativeEntriesView.backgroundColor = .coremelysisNegative
        neutralEntriesView.backgroundColor = .coremelysisNeutral

        view.addSubview(positiveEntriesView)
        view.addSubview(negativeEntriesView)
        view.addSubview(neutralEntriesView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            numberOfEntriesLabel.topAnchor.constraint(equalTo: view.topAnchor),
            numberOfEntriesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            numberOfEntriesLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            numberOfEntriesLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),

            positiveEntriesView.topAnchor.constraint(equalTo: view.topAnchor),
            positiveEntriesView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                       multiplier: CGFloat(viewModel.percentageOfPositiveEntries)),
            positiveEntriesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            positiveEntriesView.trailingAnchor.constraint(equalTo: negativeEntriesView.leadingAnchor),

            negativeEntriesView.topAnchor.constraint(equalTo: view.topAnchor),
            negativeEntriesView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                       multiplier: CGFloat(viewModel.percentageOfNegativeEntries)),
            negativeEntriesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            negativeEntriesView.trailingAnchor.constraint(equalTo: neutralEntriesView.leadingAnchor),

            neutralEntriesView.topAnchor.constraint(equalTo: view.topAnchor),
            neutralEntriesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            neutralEntriesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            neutralEntriesView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                      multiplier: CGFloat(viewModel.percentageOfNeutralEntries))

        ])
    }

}
