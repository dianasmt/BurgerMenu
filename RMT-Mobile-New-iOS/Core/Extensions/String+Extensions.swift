//
//  String.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 14.07.2022.
//

import Foundation

extension String {
    static var empty: String { return String() }
    
    private static func SBLocalString(_ key: String, language: String) -> String {
        if let rp = Bundle.main.path(forResource: language, ofType: "lproj"),
           let value = Bundle(path: rp)?.localizedString(forKey: key, value: nil, table: nil) {
            return value
        }
        return key
    }
    
    static func localString(stringKey: String, language: Languages = Languages.current) -> String {
        return SBLocalString(stringKey, language: language.rawValue)
    }
    
    static func getCurrenDate() -> String {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: currentDate)
    }
    
    static var currentWeekday: String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let currentDateString: String = dateFormatter.string(from: date)
        return currentDateString
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension String {
    func setPhoneNumberMask(mask: String, string: String, range: NSRange, maskCharacter: String) -> String {
        let text = self
        let phone = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phone.replacingOccurrences(of: "[^0-9]",
                                                with: "",
                                                options: .regularExpression)
        var result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == Character(maskCharacter) {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
    
    func replace(string: String, replacement: String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
