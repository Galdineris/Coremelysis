//
//  HistoryEntry.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 26/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation
import CoremelysisML

struct HistoryEntry {
    let creationDate: Date
    let inference: Sentiment
    let content: String
}

#if DEBUG
extension HistoryEntry {
    /// Creates
    static func create(_ amount: Int) -> [HistoryEntry] {
        var entries = [HistoryEntry]()
        for _ in 0..<amount {
            let entry = HistoryEntry(creationDate: Date(),
                                    inference: Sentiment.notFound,
                                    content: "CONTENT")
            entries.append(entry)
        }
        return entries
    }
}
#endif
