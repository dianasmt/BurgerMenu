//
//  Languages.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 20.07.2022.
//

import Foundation

enum Languages: String {
    
    // MARK: - Static
    static var current: Languages {
        get { return Languages(rawValue: UserDefaults.language) ?? .rus }
        set { UserDefaults.language = newValue.rawValue }
    }
    
    // MARK: - Cases
    case eng = "en"
    case rus = "ru"
}
