//
//  MainViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 18/08/20.
//  Copyright © 2020 Rafael Galdino. All rights rSwift Compiler Warning Groupeserved.
//

import NaturalLanguage
import CoremelysisML
import Intents

protocol MainViewModelDelegate: AnyObject {

}

final class MainViewModel {

    private let coreDataStack: CoreDataStack

    weak var delegate: MainViewModelDelegate?

    func analyze(_ paragraph: String) -> Sentiment {
        donateAnalysisIntent(paragraph)
        let sentiment = Sentiment.of(MLManager.infer(paragraph))

        save(entry: HistoryEntry(creationDate: Date(),
                                 inference: sentiment,
                                 content: paragraph))

        return sentiment
    }

    private func donateAnalysisIntent(_ data: String, _ model: Model =  .naturalLanguage) {
        let intent =  MakeAnalysisIntent()
        intent.text = data
        intent.model = NSNumber(value: model.rawValue)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate(completion: nil)
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
