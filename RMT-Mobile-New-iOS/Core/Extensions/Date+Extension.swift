//
//  Date+Extension.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.09.2022.
//

import Foundation

extension Date {
    static var currentWeekdayIndex: Int {
        var index = Calendar.current.component(.weekday, from: Date())
        index = index == 1 ? 6 : index - 2
        return index
    }
}
