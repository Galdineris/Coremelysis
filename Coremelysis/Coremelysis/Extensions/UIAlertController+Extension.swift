//
//  UIAlertController+Extension.swift
//  Coremelysis
//
//  Created by Rafael Galdino on 19/11/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title text: String = "An error occurred", errorDescription error: String = "") {
        self.init(title: text, message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] (_) in
            self?.dismiss(animated: true, completion: nil)
        }
        self.addAction(okAction)
    }
}
