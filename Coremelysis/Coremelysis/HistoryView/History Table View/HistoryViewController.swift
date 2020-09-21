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
        title = "History"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

// - MARK: Layout
    /// Configures the main view.
    private func setupView() {
        view.backgroundColor = .systemBackground
        addChild(summaryViewController)
        view.addSubview(summaryViewController.view)
        summaryViewController.didMove(toParent: self)
        summaryViewController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(historyTableView)
    }

    private func setupHistoryTableView() {
        historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.delegate = self
        historyTableView.dataSource = self

        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.estimatedRowHeight = DesignSystem.TableView.Rows.estimatedRowHeight
        historyTableView.separatorStyle = .none
    }

    /// Layouts constraints.
    private func setupConstraints() {

        let guides = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            summaryViewController.view.widthAnchor.constraint(equalTo: guides.widthAnchor),
            summaryViewController.view.topAnchor.constraint(equalTo: guides.topAnchor),
            summaryViewController.view.heightAnchor.constraint(equalTo: guides.heightAnchor, multiplier: 0.3),

            historyTableView.topAnchor.constraint(equalTo: summaryViewController.view.bottomAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: guides.bottomAnchor),
            historyTableView.widthAnchor.constraint(equalTo: guides.widthAnchor)
        ])
    }
}

// - MARK: UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {

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

        let creationDate = viewModel.creationDateOfEntry(at: indexPath.row)
        let content = viewModel.contentOfEntry(at: indexPath.row)
        let sentiment = viewModel.sentimentOfEntry(at: indexPath.row)

        cell.configure(withCreationDate: creationDate, content: content, sentiment: sentiment)
        
        return cell
    }
}

extension HistoryViewController: HistoryViewModelDelegate {
    func updateUI() {
        historyTableView.reloadData()
        summaryViewController.update(with: <#T##HistorySummaryViewModel#>)
    }
}
