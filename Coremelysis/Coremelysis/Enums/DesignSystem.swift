//
//  DesignSystem.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 15/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

enum DesignSystem {
    enum Button {
        static let height: CGFloat = 50
    }

    enum Spacing {
        static let `default`: CGFloat = 20
        static let fromNavigation: CGFloat = 50
    }

    enum TableView {
        enum Rows {
            static let estimatedRowHeight: CGFloat = 44
            static let internalSpacing: CGFloat = 10
        }
    }
}
