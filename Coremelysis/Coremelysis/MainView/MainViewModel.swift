//
//  MainViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 18/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import NaturalLanguage

protocol MainViewModelDelegate: AnyObject {

}

final class MainViewModel {

    weak var delegate: MainViewModelDelegate?
    private let mlManager: MLManager

    init(mlManager: MLManager) {
        self.mlManager = mlManager
    }

    func analyze(_ paragraph: String) -> String {
        let score = mlManager.analyze(paragraph)

        switch score {
        case -1 ... -0.5:
            return Sentiment.awful.rawValue
        case ..<0:
            return Sentiment.bad.rawValue
        case 0:
            return Sentiment.neutral.rawValue
        case ..<0.5:
            return Sentiment.good.rawValue
        case ...1:
            return Sentiment.great.rawValue
        default:
            return Sentiment.notFound.rawValue
        }
    }
}
