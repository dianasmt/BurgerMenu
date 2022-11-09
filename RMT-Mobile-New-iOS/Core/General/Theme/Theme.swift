//
//  Theme.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 05.09.2022.
//

import Foundation
import UIKit

struct Theme: Equatable {
    static let light = Theme(type: .light, colors: .light)
    static let dark = Theme(type: .dark, colors: .dark)

    enum `Type` {
        case light
        case dark
    }
    let type: Type
    let colors: ColorPalette
    
    var welcomePageLogo: UIImage? {
        switch type {
        case .dark:
            return UIImage(named: "welcome_screen_logo_dark")
        case .light:
            return UIImage(named: "welcome_screen_logo")
        }
    }

    init(type: Type, colors: ColorPalette) {
        self.type = type
        self.colors = colors
    }

    static func == (lhs: Theme, rhs: Theme) -> Bool {
        return lhs.type == rhs.type
    }
}
