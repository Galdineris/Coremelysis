//
//  HistoryViewModel.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 26/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import CoreData
import CoremelysisML

protocol HistoryViewModelDelegate: AnyObject {
    func showError(_ error: HistoryViewModel.Error )
    func beginUpdate()
    func insertNewEntryAt(_ index: IndexPath)
    func endUpdate()
}

/// The `HistoryViewController`'s ViewModel
final class HistoryViewModel: NSObject {
    // - MARK: Error enum
    enum Error {
        case failedToFetchEntries
    }

    // - MARK: Properties

    private let coreDataStack: CoreDataStack

    private(set) lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: false)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.coreDataStack.mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    /// The number of positive entries.
    /// `Good` and `Great` are considerate positive entries.
    private var numberOfPositiveEntries: Int {
        guard let entries = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return entries.filter {
            Sentiment.match($0.inference ?? "") == .good || Sentiment.match($0.inference ?? "") == .great
        }.count
    }

    /// The number of negative entries.
    /// `Awful` and `Bad` are considerate negative entries.
    private var numberOfNegativeEntries: Int {
        guard let entries = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return entries.filter {
            Sentiment.match($0.inference ?? "") == .bad || Sentiment.match($0.inference ?? "") == .awful
        }.count
    }

    /// The number of neutral entries.
    /// `Neutral` and `Not found` are considerate neutral entries.
    private var numberOfNeutralEntries: Int {
        guard let entries = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return entries.filter {
            Sentiment.match($0.inference ?? "") == .neutral
        }.count
    }

    /// The total number of entries.
    var numberOfEntries: Int {
        guard let entries = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return entries.count
    }

    weak var delegate: HistoryViewModelDelegate?

    // - MARK: Init
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // - MARK: Functions
    func fetchEntries() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            delegate?.showError(HistoryViewModel.Error.failedToFetchEntries)
        }
    }

    func viewModelAt(index: IndexPath) -> HistoryTableViewCellViewModel {
        let object = fetchedResultsController.object(at: index)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = object.createdAt else {
            return HistoryTableViewCellViewModel()
        }
        guard let inference = object.inference else {
            return HistoryTableViewCellViewModel()
        }

        guard let content = object.content else {
            return HistoryTableViewCellViewModel()
        }

        return HistoryTableViewCellViewModel(date: dateFormatter.string(from: date),
                                             inference: inference,
                                             content: content)

    }

    func buildSummary() -> HistorySummaryViewModel {
        return HistorySummaryViewModel(numberOfEntries: numberOfEntries,
                                       numberOfPositiveEntries: numberOfPositiveEntries,
                                       numberOfNegativeEntries: numberOfNegativeEntries,
                                       numberOfNeutralEntries: numberOfNeutralEntries)
    }
}

// - MARK: NSFetchedResultsControllerDelegate
extension HistoryViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.beginUpdate()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdate()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.insertNewEntryAt(newIndexPath)
                break
            }
        default:
            break
        }
    }

}
