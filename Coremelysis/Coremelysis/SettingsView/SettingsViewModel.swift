//
//  SettingsViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 27/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation
import CoremelysisML

final class SettingsViewModel {
    // - MARK: Properties
    /// The current model straight from UserDefaults through the property wrapper.
    /// `UserDefaultsAccess`. Both key and defaultValue should be set using enums to avoid
    /// hardcoded/literal strings and values.
    @UserDefaultsAccess(key: UserDefaultsKey.model.rawValue,
                        defaultValue: SAModel.default.rawValue)
    private var currentModel: String

    /// The currently selected model. It is used as a internal access to the UserDefaults key
    /// in charge of keeping the current model value.
    var selectedModel: SAModel {
        get {
            return SAModel(rawValue: currentModel) ?? .default
        }
        set {
            currentModel = newValue.rawValue
        }
    }

    /// The URL to Coremelysis's GitHub repository.
    var gitHubURL: URL? {
        return URL(string: ExternalURL.gitHub.rawValue)
    }

    /// The URL to Coremelysis's license.
    var licenseURL: URL? {
        return URL(string: ExternalURL.license.rawValue)
    }

    // - MARK: Init
    init() {
    }
}
