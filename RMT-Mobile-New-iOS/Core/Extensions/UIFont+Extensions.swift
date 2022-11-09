//
//  UIFont.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 19/07/2022.
//

import UIKit

extension UIFont {
    
    enum FontType: String {
        case black = "Black"
        case blackItalic = "BlackItalic"
        case bold = "Bold"
        case boldItalic = "BoldItalic"
        case heavy = "Heavy"
        case heavyItalic = "HeavyItalic"
        case light = "Light"
        case lightItalic = "LightItalic"
        case medium = "Medium"
        case mediumItalic = "MediumItalic"
        case regular = "Regular"
        case regularItalic = "RegularItalic"
        case semibold = "Semibold"
        case semiboldItalic = "SemiboldItalic"
        case thin = "Thin"
        case thinItalic = "ThinItalic"
        case ultralight = "Ultralight"
        case ultralightItalic = "UltralightItalic"
    }
    
    static func fontSFProText(type: FontType, size: CGFloat) -> UIFont {
        guard let fontSFProText = UIFont(name: "SFProText-" + type.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return fontSFProText
    }
   
    static func fontSFProDisplay(type: FontType, size: CGFloat) -> UIFont {
        guard let fontSFProDisplay = UIFont(name: "SFProDisplay-" + type.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return fontSFProDisplay
    }
    
    static func fontRoboto(type: FontType, size: CGFloat) -> UIFont {
        guard let fontRoboto = UIFont(name: "Roboto-" + type.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return fontRoboto
    }
}
