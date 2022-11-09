//
//  NSString+Extension.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 02.09.2022.
//

import UIKit

extension NSMutableAttributedString {
    func addClickableText(mainString: String, markedString: String, color: UIColor) {
        let nsString = NSString(string: .localString(stringKey: string))
        let range = nsString.range(of: .localString(stringKey: markedString))
        addAttribute(NSMutableAttributedString.Key.underlineStyle, value: 1, range: range)
        addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
    }
}
