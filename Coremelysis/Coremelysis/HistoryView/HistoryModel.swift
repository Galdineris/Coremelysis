//
//  HistoryModel.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 26/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation
import CoremelysisML

struct HistoryModel {
    let entries: [HistoryEntry]
}

struct HistoryEntry {
    let creationDate: Date
    let inference: Sentiment
    let content: String
}
