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

enum SAModel {
    case standard
    case sentimentPolarity
    case custom(url: String)
}

final class MLManager {
    private var model: SAModel

    init(model: SAModel = .standard) {
        self.model = model
    }

    func analyze(_ paragraph: String) -> Double {
        switch model {
        case .standard:
            return inferWithNL(paragraph)
        case .sentimentPolarity:
            return inferWithSP(paragraph)
        case .custom(url: let url):
            return 0
        }
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

    private func inferWithSP(_ data: String) -> Double {
        let spModel = SentimentPolarity()
        let tokens = extractFeatures(from: data)

        do {
            let score = try spModel.prediction(input: tokens)
            switch score.classLabel {
            case "Pos":
                return 1.0
            case "Neg":
                return -1.0
            default:
                return 0
            }
        } catch {
            // TODO: Error handling
            return 0
        }
    }

    private func extractFeatures(from data: String) -> [String: Double] {
        var tokens = [String: Double]()

        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        let scheme: NLTagScheme = NLTagScheme.nameType
        let tagger: NLTagger = NLTagger(tagSchemes: [scheme])

        tagger.string = data

        let range =  data.startIndex..<data.endIndex

        tagger.enumerateTags(in: range, unit: .word, scheme: scheme, options: options) { (_, tokenRange) -> Bool in
            let token = data[tokenRange].lowercased()

            if token.count > 3 {
                if let value = tokens[token] {
                    tokens[token] = value + 1.0
                } else {
                    tokens[token] = 1.0
                }
            }
            return true
        }
        return tokens
    }
}
