//
//  CurrencyService.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 02.09.2022.
//

import Foundation
import Moya

enum CurrencyService {
    case getCurrencyRates
}

extension CurrencyService: TargetType {
    private enum ServiceKeys {
        static let baseURL = "https://cbr.ru"
        static let currentRatesPath = "/scripts/XML_daily.asp"
        static let currentRatesHeaderValue = "application/xml"
    }
    private enum ParserKeys {
        static let currentRatesParameter = "date_req"
        static let currentRatesHeader = "Content-type"
    }
    
    var baseURL: URL {
        return URL(string: ServiceKeys.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getCurrencyRates:
            return ServiceKeys.currentRatesPath
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCurrencyRates:
            return .get
        }
    }
    
    var task: Task {
        return .requestParameters(
            parameters: [ParserKeys.currentRatesParameter: String.getCurrenDate()],
            encoding: URLEncoding.default)
    }
    
    var headers: [String: String]? {
        return [ParserKeys.currentRatesHeader: ServiceKeys.currentRatesHeaderValue]
    }
    
    var sampleData: Data {
        return Data()
    }
}
