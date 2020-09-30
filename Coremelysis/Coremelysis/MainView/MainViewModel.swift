//
//  MainViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 18/08/20.
//  Copyright © 2020 Rafael Galdino. All rights rSwift Compiler Warning Groupeserved.
//

import NaturalLanguage
import CoremelysisML
import Intents

protocol MainViewModelDelegate: AnyObject {

}

final class MainViewModel {

    weak var delegate: MainViewModelDelegate?

    func analyze(_ paragraph: String) -> String {
        donateAnalysisIntent(paragraph)
        return Sentiment.of(MLManager.infer(paragraph)).rawValue
    }

    private func donateAnalysisIntent(_ data: String, _ model: Model =  .naturalLanguage) {
        let intent =  MakeAnalysisIntent()
        intent.text = data
        intent.model = model
    }
}
