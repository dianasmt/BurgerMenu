//
//  Themable.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 05.09.2022.
//

import Foundation
import UIKit

protocol Themeable: AnyObject {
    func setupTheme(theme: Theme)
}

extension Themeable {
    var themeProvider: ThemeProvider {
        return DarkThemeProvider.shared
    }
}
