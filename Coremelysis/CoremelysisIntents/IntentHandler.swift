//
//  IntentHandler.swift
//  CoremelysisIntents
//
//  Created by Rafael Galdino on 22/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Intents
import CoremelysisML

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        switch intent {
        case is MakeAnalysisIntent:
            return MakeAnalysisIntentHandler()
        default:
            fatalError("No handle for this intent")
        }
    }
}
