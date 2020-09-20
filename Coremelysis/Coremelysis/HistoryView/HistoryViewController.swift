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
        view.addSubview(summaryView)
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
            summaryView.widthAnchor.constraint(equalTo: guides.widthAnchor),
            summaryView.topAnchor.constraint(equalTo: guides.topAnchor),
            summaryView.heightAnchor.constraint(equalTo: guides.heightAnchor, multiplier: 0.3),

            historyTableView.topAnchor.constraint(equalTo: summaryView.bottomAnchor),
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
    }
}
