//
//  CurrencyExchangeWorker.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 29.08.2022.
//

import Foundation
import RxSwift

protocol CurrencyExchangeWorkerLogic {
    func getCurrencyExchangeData() -> Observable<[CurrencyRateModel]>
}

class CurrencyExchangeWorker: CurrencyExchangeWorkerLogic {
    private let networkManager: CurrencyExchangeNetworkManagerLogic
    
    init(manager: CurrencyExchangeNetworkManagerLogic) {
        self.networkManager = manager
    }
    
    func getCurrencyExchangeData() -> Observable<[CurrencyRateModel]> {
        return networkManager.getCurrencyRates()
    }
}
