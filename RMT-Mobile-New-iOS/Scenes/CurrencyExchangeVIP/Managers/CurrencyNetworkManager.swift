//
//  CurrencyExchangeRateAPICaller.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 30.08.2022.
//

import Foundation
import Moya
import RxSwift

protocol CurrencyExchangeNetworkManagerLogic {
    func getCurrencyRates() -> Observable<[CurrencyRateModel]>
}

class CurrencyExchangeNetworkManager: CurrencyExchangeNetworkManagerLogic {
    private let provider = MoyaProvider<CurrencyService>()
    
    func getCurrencyRates() -> Observable<[CurrencyRateModel]> {
        return provider.rx
            .request(.getCurrencyRates)
            .asObservable()
            .flatMap({response -> Observable<[CurrencyRateModel]> in
                return CurrencyExchangeXMLParser(parser: XMLParser(data: response.data))
                    .getRates()
            })
    }
}
