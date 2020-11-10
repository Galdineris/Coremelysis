//
//  CustomSAModel.swift
//  CoremelysisML
//
//  Created by Rafael Galdino on 09/11/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import CoreML

/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class CustomSAModelInput: MLFeatureProvider {

    /// Features extracted from the text. as dictionary of strings to doubles
    var input: [String: Double]

    var featureNames: Set<String> {
        return ["input"]
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "input" {
            return try? MLFeatureValue(dictionary: input as [NSObject: NSNumber])
        }
        return nil
    }

    init(input: [String: Double]) {
        self.input = input
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class CustomSAModelOutput: MLFeatureProvider {

    /// Source provided by CoreML

    private let provider: MLFeatureProvider

    /// The most likely polarity (positive or negative), for the given input. as string value
    lazy var classLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")?.stringValue ?? String()
    }()

    /// The probabilities for each class label, for the given input. as dictionary of strings to doubles
    lazy var classProbability: [String: Double] = {
        [unowned self] in return self.provider.featureValue(for: "classProbability")?.dictionaryValue as? [String: Double] ?? [String: Double]()
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(classLabel: String, classProbability: [String: Double]) {
        let classLabel = MLFeatureValue(string: classLabel)
        guard let classProbability = try? MLFeatureValue(dictionary: classProbability as [AnyHashable: NSNumber]),
              let provider = try? MLDictionaryFeatureProvider(dictionary:
                                                                ["classLabel": classLabel,
                                                                 "classProbability": classProbability]) else {
            fatalError()
        }
        self.provider = provider
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}

/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class CustomSAModel {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    let urlOfModel: URL

    /**
        Construct CustomSAModel instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of CustomSAModel.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `CustomSAModel.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(modelURL: URL, model: MLModel) {
        self.model = model
        self.urlOfModel = modelURL
    }

    /**
        Construct CustomSAModel instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(modelURL: modelURL, model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(modelURL: modelURL, model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct CustomSAModel instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<CustomSAModel, Error>) -> Void) {
        return self.load(contentsOf: modelURL, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct CustomSAModel instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<CustomSAModel, Error>) -> Void) {
        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
            if let error = error {
                handler(.failure(error))
            } else if let model = model {
                handler(.success(CustomSAModel(modelURL: modelURL, model: model)))
            } else {
                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
            }
        }
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as CustomSAModelInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as CustomSAModelOutput
    */
    func prediction(input: CustomSAModelInput) throws -> CustomSAModelOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as CustomSAModelInput
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as CustomSAModelOutput
    */
    func prediction(input: CustomSAModelInput, options: MLPredictionOptions) throws -> CustomSAModelOutput {
        let outFeatures = try model.prediction(from: input, options: options)
        return CustomSAModelOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - input: Features extracted from the text. as dictionary of strings to doubles

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as CustomSAModelOutput
    */
    func prediction(input: [String: Double]) throws -> CustomSAModelOutput {
        let inputPrediction = CustomSAModelInput(input: input)
        return try self.prediction(input: inputPrediction)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [CustomSAModelInput]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [CustomSAModelOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [CustomSAModelInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [CustomSAModelOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results: [CustomSAModelOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  CustomSAModelOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
