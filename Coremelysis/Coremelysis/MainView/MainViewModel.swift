//
//  MainViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 18/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import NaturalLanguage

protocol MainViewModelDelegate: AnyObject {

}

final class MainViewModel {

    private let coreDataStack: CoreDataStack

    weak var delegate: MainViewModelDelegate?

    func analyze(_ paragraph: String) -> Sentiment {
        guard let score = MLManager.analyze(paragraph) else {
            return Sentiment.notFound
        }

        if Sentiment.of(score) != .notFound {
            let entry = HistoryEntry(creationDate: Date(),
                                     inference: Sentiment.of(score),
                                     content: paragraph)
            save(entry: entry)
        }
        
        return Sentiment.of(score)
    }

    private func save(entry: HistoryEntry) {
        let cdEntry = Entry(context: coreDataStack.mainContext)
        cdEntry.content = entry.content
        cdEntry.inference = entry.inference.rawValue

        coreDataStack.save()
    }

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}
