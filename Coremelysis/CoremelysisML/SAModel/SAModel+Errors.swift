//
//  MLError.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 15/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

extension SAModel {
    /// Coremelysis's Machine Learning Errors
    enum Errors: Error {
        /// Machine Learning Error
        case failedPrediction
        /// Machine Learning Error
        case insufficientData
        /// Machine Learning Error
        case modelNotAvaiable
        /// Machine Learning Error
        case noModelProvided
    }
}

extension SAModel.Errors: CustomStringConvertible {
    var description: String {
        switch self {
        case .failedPrediction:
            return "Model was not capable of making a prediction."
        case .insufficientData:
            return "The data was not sufficient to perform the analysis."
        case .modelNotAvaiable:
            return "The model selected could not be used."
        case .noModelProvided:
            return "There was no model provided."
        }
    }
}
