//
//  MLManager.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 09/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//
import Foundation
/// Machine Learning abstraction for making inferences.
///
public enum SAModel: String, Hashable {
    /// Apple's [Natural Language](https://developer.apple.com/documentation/naturallanguage) framework
    case `default`

    /// Vadym Markov's Sentiment Polarity mlmodel implementation
    ///
    ///[Source on Github](https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/SentimentPolarity/Resources/SentimentPolarity.mlmodel)
    case sentimentPolarity

    /// Custom Models
    case customModel
}
