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

    weak var delegate: SettingsViewModelDelegate?

    init() {
        
    }
}
