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
    let percentageOfPositiveEntries: Float
    let percentageOfNegativeEntries: Float
    let percentageOfNeutralEntries: Float

    init(numberOfEntries: Int,
         percentageOfPositiveEntries: Float,
         percentageOfNegativeEntries: Float,
         percentageOfNeutralEntries: Float) {
        self.numberOfEntries = "\(numberOfEntries) entries"
        self.percentageOfPositiveEntries = percentageOfPositiveEntries / 2
        self.percentageOfNegativeEntries = percentageOfNegativeEntries / 2
        self.percentageOfNeutralEntries = percentageOfNeutralEntries / 2
    }

    init() {
        self.numberOfEntries = ""
        self.percentageOfPositiveEntries = 0
        self.percentageOfNeutralEntries = 0
        self.percentageOfNegativeEntries = 0
    }
}
