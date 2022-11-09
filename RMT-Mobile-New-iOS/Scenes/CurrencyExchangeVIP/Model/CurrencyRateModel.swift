//
//  CurrencyRateModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 30.08.2022.
//

import Foundation

struct CurrencyRateModel: Codable {
    let numCode: Int
    let charCode: String
    let nominal: Int
    let name: String
    let value: Double
}
