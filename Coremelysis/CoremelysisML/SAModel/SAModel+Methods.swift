//
//  SAModel+Methods.swift
//  CoremelysisML
//
//  Created by Rafael Galdino on 02/11/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import NaturalLanguage
import CoreML

extension SAModel {
    // MARK: Exposed Methods
    ///Gives the predicted sentiment value of a given paragraph. Throws errors.
    ///
    ///Performs sentiment analysis using Apple's [Natural Language](https://developer.apple.com/documentation/naturallanguage) framework or another specified model
    ///and it's return value ranges from -1 to 1, for negative and positive values, respectively.
    /// - Parameters:
    ///     - text: Body of text used in the inference. Should be at least one sentence long.
    ///     - model: Model used for the inference.
    public func infer(text: String) throws -> Double {
        switch self {
        case .sentimentPolarity:
            return try SAModel.inferenceBySentimentPolarity(text)
        case .default:
            return try SAModel.inferenceByNaturalLanguage(text)
        case .customModel:
            return try SAModel.inferenceByCustomModel(text)
        @unknown default:
            throw Errors.noModelProvided
        }
    }

    // MARK: Inference Methods
    ///Uses Natural Language framework to give the predicted sentiment value of a string.
    ///
    ///Performs sentiment analysis using Apple's [Natural Language](https://developer.apple.com/documentation/naturallanguage)
    ///framework and it's return value ranges from -1 to 1, for negative and positive values, respectively.
    /// - Parameters:
    ///     - data: Body of text used in the inference. Should be at least one sentence long.
    private static func inferenceByNaturalLanguage(_ data: String) throws -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])

        tagger.string = data

        let inferenceValue = tagger.tag(at: data.startIndex, unit: .paragraph, scheme: .sentimentScore).0

        guard let inference = Double(inferenceValue?.rawValue ?? "nil") else {
            throw Errors.failedPrediction
        }

        return inference
    }

    ///Uses Sentiment Polarity model to give the predicted sentiment value of a string.
    ///
    ///Performs sentiment analysis using [Vadym Markov's Sentiment Polarity](https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/SentimentPolarity/Resources/SentimentPolarity.mlmodel) model.
    /// - Parameters:
    ///     - data: Body of text used in the inference. Should be at least one sentence long.
    private static func inferenceBySentimentPolarity(_ data: String) throws -> Double {
        let spModel = try SentimentPolarity(configuration: MLModelConfiguration())
        let tokens = extractFeatures(from: data)

        if tokens.isEmpty {
            throw Errors.insufficientData
        }

        let prediction = try spModel.prediction(input: tokens)
        guard let score = prediction.classProbability[prediction.classLabel] else {
            throw Errors.failedPrediction
        }
        if prediction.classLabel == "Pos" {
            return score
        } else {
            return -score
        }
    }

    private static func inferenceByCustomModel(_ data: String) throws -> Double {
        guard let path = UserDefaults.standard.string(forKey: "customModel"), !path.isEmpty else {
            throw Errors.modelNotAvaiable
        }
        let modelURL = URL(fileURLWithPath: path)
        let modelConfig = MLModelConfiguration()
        let customModel = try CustomSAModel(contentsOf: modelURL, configuration: modelConfig)
        let tokens = extractFeatures(from: data)

        if tokens.isEmpty {
            throw Errors.insufficientData
        }

        let prediction = try customModel.prediction(input: tokens)
        guard let score = prediction.classProbability[prediction.classLabel] else {
            throw Errors.failedPrediction
        }
        return score
    }

    // MARK: Auxiliary Methods
    ///Uses Apple's Natural Language framework to extract tokens from text data.
    ///
    ///It ignores punctuation and symbols
    ///words with 3 or less characters are not considered.
    /// - Parameters:
    ///     - data: Text to be suffer feature extraction.
    ///     - wordSize:
    static func extractFeatures(from data: String, wordSize: Int = 3) -> [String: Double] {
        var tokens = [String: Double]()

        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        let scheme: NLTagScheme = NLTagScheme.nameType
        let tagger: NLTagger = NLTagger(tagSchemes: [scheme])

        tagger.string = data

        let range =  data.startIndex..<data.endIndex

        tagger.enumerateTags(in: range, unit: .word, scheme: scheme, options: options) { (_, tokenRange) -> Bool in
            let token = data[tokenRange].lowercased()

            if token.count > wordSize {
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

    public static func downloadModel(from externalURL: URL) throws {
        var downloadError: Error?
        FileManager.downloadFile(from: externalURL) { (result) in
            switch result {
            case .success(let url):
                do {
                    deleteCustomModel()
                    let compiledModelURL = try MLModel.compileModel(at: url)
                    let permanentURL = FileManager.persistFile(fileURL: compiledModelURL)
                    UserDefaults.standard.setValue(permanentURL, forKey: "customModel")
                } catch {
                    downloadError = error
                }
            case .failure(let error):
                downloadError = error
            }
        }
        if let error = downloadError {
            throw error
        }
    }

    public static func deleteCustomModel() {
        guard let path = UserDefaults.standard.string(forKey: "customModel"), !path.isEmpty else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            UserDefaults.standard.setValue(String(), forKey: "customModel")
        } catch {
            return
        }
    }
}
