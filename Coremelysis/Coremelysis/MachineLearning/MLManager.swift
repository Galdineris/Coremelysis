//
//  MLManager.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 09/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation
import NaturalLanguage
import CoreML

class MLManager {
    var model: MLModel?

    init(model: MLModel? = nil) {
        self.model = model
    }

    func analyze(_ paragraph: String) -> Double {
        guard let model = model else {
            return inferWithNL(paragraph)
        }
        return 0
    }

    private func inferWithNL(_ data: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])

        tagger.string = data

        let inferenceValue = tagger.tag(at: data.startIndex, unit: .paragraph, scheme: .sentimentScore).0

        guard let inference = Double(inferenceValue?.rawValue ?? "nil") else {
            // TODO: Error handling
            return 0
        }

        return inference
    }
}
