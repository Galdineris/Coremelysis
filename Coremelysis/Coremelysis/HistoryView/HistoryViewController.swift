//
//  HistoryViewController.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 26/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation
import UIKit

final class HistoryViewController: UIViewController {
    @AutoLayout private var historyTableView: UITableView
    @AutoLayout private var summaryView: UIView

    private let viewModel: HistoryViewModel

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Fatal Error: ViewController should not be deserialized.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        title = "History"

        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(historyTableView)
        view.addSubview(summaryView)

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
