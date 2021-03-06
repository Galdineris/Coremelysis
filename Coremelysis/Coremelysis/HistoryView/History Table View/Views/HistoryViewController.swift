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
    private var summaryViewController: HistorySummaryViewController

    /// The ViewModel of this type.
    private let viewModel: HistoryViewModel

    // - MARK: Init
    init(viewModel: HistoryViewModel, summaryViewController: HistorySummaryViewController) {
        self.viewModel = viewModel
        self.summaryViewController = summaryViewController
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error: ViewController should not be deserialized.")
    }

    // - MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHistoryTableView()
        setupConstraints()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareSummary))
        self.navigationItem.rightBarButtonItem?.tintColor = .coremelysisAccent
        title = "History"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        summaryViewController.update(with: viewModel.buildSummary())
    }

    @objc func shareSummary() {
        let summary = viewModel.buildSummary()
        let items: [String] = ["""
        Total number of entries: \(summary.numberOfEntries).
        Positive: \(summary.numberOfPositiveEntries) |
        Negative: \(summary.numberOfNegativeEntries) |
        Neutral: \(summary.numberOfNeutralEntries)
        """]
        let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    // - MARK: Layout
    /// Configures the main view.
    private func setupView() {
        view.backgroundColor = .systemBackground
        addChild(summaryViewController)
        view.addSubview(summaryViewController.view)
        summaryViewController.didMove(toParent: self)
        summaryViewController.view.translatesAutoresizingMaskIntoConstraints = false
        summaryViewController.update(with: viewModel.buildSummary())

        view.addSubview(historyTableView)
    }

    private func setupHistoryTableView() {
        historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.delegate = self
        historyTableView.dataSource = self

        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.estimatedRowHeight = DesignSystem.TableView.Rows.estimatedRowHeight
        historyTableView.separatorStyle = .none

        viewModel.fetchEntries()
    }

    /// Layouts constraints.
    private func setupConstraints() {

        let safeAreaGuides = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            summaryViewController.view.leftAnchor.constraint(equalTo: safeAreaGuides.leftAnchor),
            summaryViewController.view.rightAnchor.constraint(equalTo: safeAreaGuides.rightAnchor),
            summaryViewController.view.topAnchor.constraint(equalTo: safeAreaGuides.topAnchor),
            summaryViewController.view.heightAnchor.constraint(equalTo: safeAreaGuides.heightAnchor, multiplier: 0.3),

            historyTableView.topAnchor.constraint(equalTo: summaryViewController.view.bottomAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: safeAreaGuides.bottomAnchor),
            historyTableView.widthAnchor.constraint(equalTo: safeAreaGuides.widthAnchor)
        ])
    }
}

// - MARK: UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteEntryAt(indexPath)
        }
    }
}

// - MARK: UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfEntries
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as? HistoryTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: viewModel.viewModelAt(index: indexPath))

        return cell
    }
}

// - MARK: HistoryViewModelDelegate
extension HistoryViewController: HistoryViewModelDelegate {
    func deleteEntryAt(_ index: IndexPath) {
        historyTableView.deleteRows(at: [index], with: .fade)
    }

    func beginUpdate() {
        historyTableView.beginUpdates()
    }

    func insertNewEntryAt(_ index: IndexPath) {
        historyTableView.insertRows(at: [index], with: .fade)
    }

    func endUpdate() {
        historyTableView.endUpdates()
        summaryViewController.update(with: viewModel.buildSummary())
    }

    func showError(_ error: HistoryViewModel.Error) {
        // - TODO: Error handling
    }

}
