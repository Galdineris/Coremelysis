//
//  HistorySummaryViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 21/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

struct HistorySummaryViewModel {
    let numberOfEntries: String
    let numberOfPositiveEntries: String
    let numberOfNegativeEntries: String
    let numberOfNeutralEntries: String

    init(numberOfEntries: Int = 0,
         numberOfPositiveEntries: Int = 0,
         numberOfNegativeEntries: Int = 0,
         numberOfNeutralEntries: Int = 0) {
        self.numberOfEntries = "\(numberOfEntries) entries"
        self.numberOfPositiveEntries = "\(numberOfPositiveEntries)"
        self.numberOfNegativeEntries = "\(numberOfNegativeEntries)"
        self.numberOfNeutralEntries = "\(numberOfNeutralEntries)"
    }
}
