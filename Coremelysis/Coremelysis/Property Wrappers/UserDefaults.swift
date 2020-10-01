//
//  UserDefaults.swift
//  Coremelysis
//
//  Created by Artur Carneiro on 26/09/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefaultsAccess<T> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaults

    init(key: String,
         defaultValue: T,
         userDefaults: UserDefaults = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
