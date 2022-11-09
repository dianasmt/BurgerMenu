//
//  UserDefault.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 18.07.2022.
//

import Foundation

extension UserDefaults {
    private enum Keys {
        static let language = "language"
        static let isNotFirstTime = "isNotFirstTime"
        static let isDark = "isDark"
    }
    
    static var language: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.language) ?? Languages.rus.rawValue
        }
        set { UserDefaults.standard.set(newValue, forKey: Keys.language) }
    }
    
    static var isNotFirstTime: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isNotFirstTime)
        }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isNotFirstTime) }
    }
    
    static var isDark: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isDark)
        }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isDark) }
    }
}
