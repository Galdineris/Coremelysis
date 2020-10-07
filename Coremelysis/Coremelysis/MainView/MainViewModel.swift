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

    /// The current model straight from UserDefaults through the property wrapper.
    /// `UserDefaultsAccess`. Both key and defaultValue should be set using enums to avoid
    /// hardcoded/literal strings and values.
    @UserDefaultsAccess(key: UserDefaultsKey.model.rawValue,
                        defaultValue: SentimentAnalysisModel.default.rawValue)
    private var currentModel: String

    func analyze(_ paragraph: String) -> Sentiment {
        var selectedModel: Model = .naturalLanguage
        var modelForInference: SentimentAnalysisModel = .default
        if currentModel == SentimentAnalysisModel.sentimentPolarity.rawValue {
            selectedModel = .sentimentPolarity
            modelForInference = .sentimentPolarity
        }
        donateAnalysisIntent(paragraph, selectedModel)
        guard let inference = MLManager.analyze(paragraph, with: modelForInference) else {
            return Sentiment.notFound
        }

        let sentiment = Sentiment.of(inference)

        if sentiment != .notFound {
            save(entry: HistoryEntry(creationDate: Date(),
                                     inference: sentiment,
                                     content: paragraph))
        }

        return sentiment
    }

    private func donateAnalysisIntent(_ data: String, _ model: Model =  .naturalLanguage) {
        let intent =  MakeAnalysisIntent()
        intent.text = data
        intent.model = model
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
