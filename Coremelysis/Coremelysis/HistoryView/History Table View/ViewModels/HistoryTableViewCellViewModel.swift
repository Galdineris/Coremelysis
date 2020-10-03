//
//  HistoryTableViewCellViewModel.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 29/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

struct HistoryTableViewCellViewModel {
    let date: String
    let inference: String
    let content: String

    init(date: String = "",
         inference: String = "",
         content: String = "") {
        self.date = date
        self.inference = inference
        self.content = content
    }
}
