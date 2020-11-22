//
//  UIViewController.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 05/11/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
