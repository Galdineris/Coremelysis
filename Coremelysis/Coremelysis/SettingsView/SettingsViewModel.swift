//
//  SettingsViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 27/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

protocol SettingsViewModelDelegate: AnyObject {
}

final class SettingsViewModel {

    @UserDefaultsAccess(key: UserDefaultsKeys.model.rawValue,
                        defaultValue: SentimentAnalysisModel.default.rawValue)
    private var currentModel: String

    var selectedModel: SentimentAnalysisModel {
        get {
            switch currentModel {
            case SentimentAnalysisModel.default.rawValue:
                return SentimentAnalysisModel.default
            case SentimentAnalysisModel.sentimentPolarity.rawValue:
                return SentimentAnalysisModel.sentimentPolarity
            case SentimentAnalysisModel.customModel.rawValue:
                return SentimentAnalysisModel.customModel
            default:
                return SentimentAnalysisModel.default
            }
        }
        set {
            currentModel = newValue.rawValue
        }
    }

    weak var delegate: SettingsViewModelDelegate?

    init() {
    }
}
