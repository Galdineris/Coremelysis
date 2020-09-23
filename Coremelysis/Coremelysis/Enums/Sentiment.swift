//
//  Sentiment.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 18/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

enum Sentiment: String {
    case good = "Good"
    case great = "Great"
    case bad = "Bad"
    case awful = "Awful"
    case neutral = "Neutral"
    case notFound = "Sentiment not found"

    static func of(_ value: Double) -> Sentiment {
        switch value {
        case -1 ... -0.5:
            return Sentiment.awful
        case ..<0:
            return Sentiment.bad
        case 0:
            return Sentiment.neutral
        case ..<0.5:
            return Sentiment.good
        case ...1:
            return Sentiment.great
        default:
            return Sentiment.notFound
        }
    }
}
