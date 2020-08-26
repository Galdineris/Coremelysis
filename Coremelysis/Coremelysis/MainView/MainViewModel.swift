//
//  MainViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 18/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import NaturalLanguage

final class MainViewModel {

    init() {

    }

    func analyze(_ paragraph: String) -> String {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])

        tagger.string = paragraph

        let analysedString = tagger.tag(at: paragraph.startIndex, unit: .paragraph, scheme: .sentimentScore).0

        if let score = Double(analysedString?.rawValue ?? "0") {
            switch score {
            case -1 ... -0.5:
                return Sentiment.awful.rawValue
            case ..<0:
                return Sentiment.bad.rawValue
            case 0:
                return Sentiment.neutral.rawValue
            case ..<0.5:
                return Sentiment.good.rawValue
            case ..<1:
                return Sentiment.great.rawValue
            default:
                return Sentiment.notFound.rawValue
            }
        }

        return Sentiment.notFound.rawValue
    }
}
