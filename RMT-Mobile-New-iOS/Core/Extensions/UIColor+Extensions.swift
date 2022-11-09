//
//  UIColor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.07.22.
//

import UIKit

extension UIColor {
    
    // MARK: - Custom colors
    static let customYellow = UIColor(hex: "#FFCC00")
    static let customDarkerYellow = UIColor(hex: "#FFE169")
    static let customPaleYellow = UIColor(hex: "#FAE07A")
    static let customBlack = UIColor(hex: "#212529")
    static let customGray = UIColor(hex: "#8A8A8D")
    static let customRed = UIColor(hex: "#FF3B30")
    static let customGreen = UIColor(hex: "#4CAF50")
    static let customWhite = UIColor(hex: "#F5F5F5")
    static let customSeparator = UIColor(hex: "#C6C6C9")
    static let darkGreyColor = UIColor(hex: "#9E9E9E")
    static let lightGreyColor = UIColor(hex: "#EEEEEE")
    static let customLighterGray = UIColor(hex: "FFFFFF26")
    static let customDarkGray = UIColor(hex: "#616161")
    static let darkGray = UIColor(hex: "#999999")
    static let customDarkYellow = UIColor(hex: "#FFD426")
    static let customLightYellow = UIColor(hex: "#FDF3CA")
    static let secondaryGray =  UIColor(hex: "#585859")
    static let customBackgrounDark = UIColor(hex: "#2A2831")
    static let navigationBarBackgroundDark = UIColor(hex: "#19181F")
    static let grayishBlack = UIColor(hex: "#37363E")
    static let whiteGray = UIColor(hex: "#CDCDCD")
    static let customLightPink = UIColor(hex: "#FFB6B6")
    static let customShadowGray = UIColor(hex: "#00000026")
    
    // MARK: - Initializer
    convenience init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        let length = hexSanitized.count
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        switch length {
        case 6:
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        case 8:
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        default:
            break
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
