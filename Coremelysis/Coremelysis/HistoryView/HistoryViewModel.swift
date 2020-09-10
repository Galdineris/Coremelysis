//
//  HistoryViewModel.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 26/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    
}

final class HistoryViewModel {

    weak var delegate: HistoryViewModelDelegate?
    
    init() {}
}
