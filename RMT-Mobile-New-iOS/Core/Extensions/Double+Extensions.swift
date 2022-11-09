//
//  Double+Extensions.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 02.09.2022.
//

import Foundation

extension Double {
    func rounded(to decimal: Int) -> Double {
        let divisor = pow(10.0, Double(decimal))
        return (self * divisor).rounded() / divisor
    }
}
