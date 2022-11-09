//
//  CurrencyExchangeModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 11.08.2022.
//

import Foundation
import Differentiator

struct CurrencyModel {
    let flagImage: String
    let title: String
    let description: String
    let valueBuy: Double
    let valueSell: Double 
}

struct CurrencyDataSource {
    var items: [CurrencyModel]
}

extension CurrencyDataSource: SectionModelType {
    init(original: CurrencyDataSource, items: [CurrencyModel]) {
        self = original
        self.items = items
    }
}
