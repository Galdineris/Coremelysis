//
//  HistoryViewModel.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 26/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    func updateUI()
}

/// The `HistoryViewController`'s ViewModel
final class HistoryViewModel {
// - MARK: Properties
    /// The array of `HistoryEntry`.
    private var model: [HistoryEntry] = HistoryEntry.create(30) {
        /// Currently, it uses a development-only implementation to create samples for testing purpose.
        didSet {
            self.delegate?.updateUI()
        }
    }

    var numberOfEntries: Int {
        return model.count
    }

    weak var delegate: HistoryViewModelDelegate?

// - MARK: Init
    init() {

    }

// - MARK: Functions
    func creationDateOfEntry(at index: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy mm dd"
        return dateFormatter.string(from: model[index].creationDate)
    }

    func sentimentOfEntry(at index: Int) -> Sentiment {
        return model[index].inference
    }

    func contentOfEntry(at index: Int) -> String {
        return model[index].content
    }

}
