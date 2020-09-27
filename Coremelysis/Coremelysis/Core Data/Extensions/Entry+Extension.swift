//
//  Entry+Extension.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 27/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import CoreData

extension Entry {
    public override func awakeFromInsert() {
        self.createdAt = Date()
    }
}
