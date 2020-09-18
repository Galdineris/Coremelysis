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

    func analyze(_ paragraph: String) -> Sentiment {
        let score = mlManager.analyze(paragraph)

        switch score {
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
