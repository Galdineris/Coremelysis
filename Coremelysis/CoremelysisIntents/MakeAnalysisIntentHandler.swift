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
            let inference = MLManager.infer(text)
            completion(MakeAnalysisIntentResponse.success(sentiment: Sentiment.of(inference).rawValue))
        } else {
            completion(MakeAnalysisIntentResponse.failure(error: "Invalid text"))
        }
    }
}
