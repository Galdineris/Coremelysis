//
//  SentimentAnalysisModel.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 16/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

/// Sentiment Analysis Model Identifiers
enum SentimentAnalysisModel: Hashable {
    /// Apple's [Natural Language](https://developer.apple.com/documentation/naturallanguage) framework
    case `default`

    /// Vadym Markov's Sentiment Polarity mlmodel implementation
    /// 
    ///[Source on Github](https://github.com/cocoa-ai/SentimentCoreMLDemo/blob/master/SentimentPolarity/Resources/SentimentPolarity.mlmodel)
    case sentimentPolarity

    /// Custom Models
    /// - url: Model's location inside the bundle.
    case customModel(url: String)
}
