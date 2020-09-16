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

    func analyze(_ paragraph: String) -> String {
        guard let score = MLManager.analyze(paragraph) else {
            return Sentiment.notFound.rawValue
        }

        return Sentiment.of(score).rawValue
    }
}
