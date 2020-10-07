//
//  MakeAnalysisIntentHandler.swift
//  CoremelysisIntents
//
//  Created by Rafael Galdino on 25/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Intents
import CoremelysisML

class MakeAnalysisIntentHandler: NSObject, MakeAnalysisIntentHandling {
    func handle(intent: MakeAnalysisIntent, completion: @escaping (MakeAnalysisIntentResponse) -> Void) {
        if let text = intent.text, text != "" {
            if intent.model != Model.unknown {
                var selectedModel: SentimentAnalysisModel = .default
                if intent.model == Model.sentimentPolarity {
                    selectedModel = .sentimentPolarity
                }
                let inference = MLManager.analyze(text, with: selectedModel)
                completion(MakeAnalysisIntentResponse.success(sentiment: Sentiment.of(inference).rawValue))
            } else {
                completion(MakeAnalysisIntentResponse.failure(error: "Invalid Model"))
            }
        } else {
            completion(MakeAnalysisIntentResponse.failure(error: "Invalid text"))
        }
    }
}
