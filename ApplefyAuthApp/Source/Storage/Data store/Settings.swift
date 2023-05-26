//
//  Settings.swift
//  ApplefyAuthApp
//
//  Created by Denys on 25.05.2023.
//

import Foundation

private let digitGroupSizeKey = "password.digitGroupSize"
private let defaultDigitGroupSize = 2

final class Settings {
    let userDefaults = UserDefaults.standard

    var digitGroupSize: Int {
        get {
            guard userDefaults.object(forKey: digitGroupSizeKey) != nil else {
                return defaultDigitGroupSize
            }
            return userDefaults.integer(forKey: digitGroupSizeKey)
        }
        set {
            userDefaults.set(newValue, forKey: digitGroupSizeKey)
        }
    }
}

