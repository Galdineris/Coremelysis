//
//  HistoryViewController.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 26/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//
import UIKit

/// The representation of the History screen of the app.
final class HistoryViewController: UIViewController {
// - MARK: Properties

    /// The history displayed in a UITableView format.
    @AutoLayout private var historyTableView: UITableView
    /// The summary of all analysis.
    @AutoLayout private var summaryView: UIView

    /// The ViewModel of this type.
    private let viewModel: HistoryViewModel

// - MARK: Init
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error: ViewController should not be deserialized.")
    }

// - MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()


        title = "History"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    /// Configures the main view.
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(historyTableView)
        view.addSubview(summaryView)
    }

    /// Layouts constraints.
    private func setupConstraints() {

        let guides = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            summaryView.widthAnchor.constraint(equalTo: guides.widthAnchor),
            summaryView.centerXAnchor.constraint(equalTo: guides.centerXAnchor),
            summaryView.topAnchor.constraint(equalTo: guides.topAnchor),
            summaryView.heightAnchor.constraint(equalTo: guides.heightAnchor, multiplier: 0.3),

            historyTableView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: guides.bottomAnchor),
            historyTableView.widthAnchor.constraint(equalTo: guides.widthAnchor),
            historyTableView.centerXAnchor.constraint(equalTo: guides.centerXAnchor)
        ])
    }
}
