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
    func handle(error: Error, retry retryHandler: (() -> Void)?)
}

final class MainViewModel {

    private let coreDataStack: CoreDataStack

    weak var delegate: MainViewModelDelegate?

    /// The current model straight from UserDefaults through the property wrapper.
    /// `UserDefaultsAccess`. Both key and defaultValue should be set using enums to avoid
    /// hardcoded/literal strings and values.
    @UserDefaultsAccess(key: UserDefaultsKey.model.rawValue,
                        defaultValue: SAModel.default.rawValue)
    private var currentModel: String

    func analyze(_ paragraph: String) -> Sentiment {
        let model = SAModel.init(rawValue: currentModel) ?? .default
        do {
            let inference = try model.infer(text: paragraph)

            let sentiment = Sentiment.of(inference)

            if sentiment != .notFound {
                save(entry: HistoryEntry(creationDate: Date(),
                                         inference: sentiment,
                                         content: paragraph))
                donateAnalysisIntent(paragraph, model)
            }

            return sentiment
        } catch {
            return Sentiment.notFound
        }
    }

    func updateModel() {
        let model = SAModel.init(rawValue: currentModel) ?? .default
        if model == .customModel {
            if let stringURL = UserDefaults.standard.string(forKey: "customModelURL") {
                let url = URL(fileURLWithPath: stringURL)
                guard (try? SAModel.downloadModel(from: url)) != nil else { return }
            }
        }
    }

    private func donateAnalysisIntent(_ data: String, _ model: SAModel =  .default) {
        let intent =  MakeAnalysisIntent()
        intent.text = data
        switch model {
        case .default:
            intent.model = SiriModel.naturalLanguage
        case .sentimentPolarity:
            intent.model = SiriModel.sentimentPolarity
        case .customModel:
            intent.model = SiriModel.unknown
        }
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate(completion: nil)
    }

    private func save(entry: HistoryEntry) {
        let cdEntry = Entry(context: coreDataStack.mainContext)
        cdEntry.content = entry.content
        cdEntry.inference = entry.inference.rawValue

        do {
            try coreDataStack.save()
        } catch {
            delegate?.handle(error: error) {[weak self] in
                self?.save(entry: entry)
            }
        }
    }

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}
