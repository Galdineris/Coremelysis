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

/// Machine Learning class abstraction for making inferences.
///
/// Should not be subclassed or instantiated.
final class MLManager {
// MARK: Exposed Methods
    ///Gives the predicted sentiment value of a given paragraph. Throws errors.
    ///
    ///Performs sentiment analysis using Apple's [Natural Language](https://developer.apple.com/documentation/naturallanguage)
    ///framework and it's return value ranges from -1 to 1, for negative and positive values, respectively.
    /// - Parameters:
    ///     - paragraph: Body of text used in the inference. Should be at least one sentence long.
    static func analyze(_ paragraph: String) throws -> Double {
        try inferWithNL(paragraph)
    }

    ///Gives the predicted sentiment value of a given paragraph. Can return nil.
    ///
    ///Performs sentiment analysis using Apple's [Natural Language](https://developer.apple.com/documentation/naturallanguage)
    ///framework and it's return value ranges from -1 to 1, for negative and positive values, respectively.
    /// - Parameters:
    ///     - paragraph: Body of text used in the inference. Should be at least one sentence long.
    static func analyze(_ paragraph: String) -> Double? {
        try? inferWithNL(paragraph)
    }

    ///Gives the predicted sentiment values of a given paragraph.
    ///
    ///Performs inferences using multiple models. Prediction values are returned in dictionary form with the models names as the keys.
    /// - Parameters:
    ///     - paragraph: Body of text used in the inference. Should be at least one sentence long.
    ///     - models: Models to be used for inference.
    static func analyze(_ paragraph: String, with models: [SentimentAnalysisModel]) throws -> [SentimentAnalysisModel: Double] {
        if models.isEmpty {
            throw MachineLearningError.noModelProvided
        }
        var predictions = [SentimentAnalysisModel: Double]()
        for model in models {
            switch model {
            case .default:
                predictions[.default] = try inferWithSP(paragraph)
            case .sentimentPolarity:
                predictions[.sentimentPolarity] = try inferWithSP(paragraph)
            case .customModel(let url):
//                TODO: Custom Machine Learning algorithims support
                predictions[.customModel(url: url)] = 0
            }
        }
        return predictions
    }

// MARK: Inference Methods
    ///Uses Natural Language framework to give the predicted sentiment value of a string.
    ///
    ///Performs sentiment analysis using Apple's [Natural Language](https://developer.apple.com/documentation/naturallanguage)
    ///framework and it's return value ranges from -1 to 1, for negative and positive values, respectively.
    /// - Parameters:
    ///     - data: Body of text used in the inference. Should be at least one sentence long.
    private static func inferWithNL(_ data: String) throws -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])

        tagger.string = data

        let inferenceValue = tagger.tag(at: data.startIndex, unit: .paragraph, scheme: .sentimentScore).0

        guard let inference = Double(inferenceValue?.rawValue ?? "nil") else {
            throw MachineLearningError.failedPrediction
        }

        return inference
    }

    ///Uses Sentiment Polarity model to give the predicted sentiment value of a string.
    ///
    ///Performs sentiment analysis using [Vadym Markov's Sentiment Polarity](https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/SentimentPolarity/Resources/SentimentPolarity.mlmodel) model.
    /// - Parameters:
    ///     - data: Body of text used in the inference. Should be at least one sentence long.
    private static func inferWithSP(_ data: String) throws -> Double {
        let spModel = SentimentPolarity()
        let tokens = extractFeatures(from: data)

        if tokens.isEmpty {
            throw MachineLearningError.insufficientData
        }

        let prediction = try spModel.prediction(input: tokens)
        guard let score = prediction.classProbability[prediction.classLabel] else {
            throw MachineLearningError.failedPrediction
        }
        if prediction.classLabel == "Pos" {
            return score
        } else {
            return -score
        }
    }
// MARK: Auxiliary Methods
    ///Uses Apple's Natural Language framework to extract tokens from text data.
    ///
    ///It ignores punctuation, symbols and words with 3 or less characters.
    /// - Parameters:
    ///     - data: Text to be suffer feature extraction.
    private static func extractFeatures(from data: String) -> [String: Double] {
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
