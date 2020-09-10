//
//  AutoLayoutPropertyWrapper.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 14/08/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

@propertyWrapper final class AutoLayout<View: UIView> {
    private lazy var view: View = {
        let view = View(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var wrappedValue: View {
        return view
    }
}
