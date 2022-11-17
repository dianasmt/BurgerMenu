//
//  CurrencyExchangeInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 11.08.2022.
//

import UIKit
import RxSwift

protocol CurrencyExchangeInteractorInput {
    func loadExchangeRates()
}

protocol CurrencyExchangeInteractorOutput {
    func displayCells(cells: [CurrencyDataSource])
}

final class CurrencyExchangeInteractor {
    enum Const {
        static let currencyName = "currency_name"
        static let sellTitle = "currency_exchange_sell"
        static let currencyBuyTitle = "currency_exchange_buy"
        static let currencySellTitle = "currency_exchange_sell"
        static let currencyDollarTitle = "USD"
        static let currencyEuroTitle = "EUR"
        static let currencyEURUSDTitle = "EUR/USD"
        static let currencyDollarFullTitle = "currency_exchange_dollar_full"
        static let currencyEuroFullTitle = "currency_exchange_euro_full"
        static let currencyEuroandDollar = "currency_exchange_euro/dollar"
        static let currencyExchangeRates = "Exchange rates"
        static let currencyError = "currency_exchange_loading_error"
        static let flagUSImageName = "currency_exchange_us_flag"
        static let flagEUImageName = "currency_exchange_eu_flag"
        static let flagUSEUImageName = "currency_exchange_us_and_eu_flag"
    }
    enum Currency: String {
        case USD
        case EUR
    }
    var presenter: CurrencyExchangeInteractorOutput?
    private let worker: CurrencyExchangeWorkerLogic
    private let bag = DisposeBag()
    
    init(worker: CurrencyExchangeWorkerLogic) {
        self.worker = worker
    }
}

extension CurrencyExchangeInteractor: CurrencyExchangeInteractorInput {
    func loadExchangeRates() {
        worker.getCurrencyExchangeData()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { weakSelf, rates in
                let necessaryRates = rates.filter {
                    $0.charCode == Currency.USD.rawValue || $0.charCode == Currency.EUR.rawValue
                }
                let cells = weakSelf.configureCells(with: necessaryRates)
                weakSelf.presenter?.displayCells(cells: cells)
            })
            .disposed(by: bag)
    }
    
    private func configureCells(with ratesList: [CurrencyRateModel]) -> [CurrencyDataSource] {
        guard let usdCurrencyRate = ratesList
                .first(where: { $0.charCode == Currency.USD.rawValue }),
              let eurCurrencyRate = ratesList
                .first(where: { $0.charCode == Currency.EUR.rawValue }) else {
                    return []
                }
        
        let cells = [
            CurrencyDataSource(items: [
                CurrencyModel(flagImage: Const.flagUSImageName,
                              title: Const.currencyDollarTitle,
                              description: .localString(stringKey: CurrencyExchangeInteractor.Const.currencyDollarFullTitle),
                              valueBuy: usdCurrencyRate.value.rounded(to: 2),
                              valueSell: usdCurrencyRate.value.rounded(to: 2)),
                CurrencyModel(flagImage: Const.flagEUImageName,
                              title: Const.currencyEuroTitle,
                              description: .localString(stringKey: CurrencyExchangeInteractor.Const.currencyEuroFullTitle),
                              valueBuy: eurCurrencyRate.value.rounded(to: 2),
                              valueSell: eurCurrencyRate.value.rounded(to: 2)),
                CurrencyModel(flagImage: Const.flagUSEUImageName,
                              title: Const.currencyEURUSDTitle,
                              description: .localString(stringKey: CurrencyExchangeInteractor.Const.currencyEuroandDollar),
                              valueBuy: (eurCurrencyRate.value / usdCurrencyRate.value)
                                .rounded(to: 2),
                              valueSell: (eurCurrencyRate.value / usdCurrencyRate.value)
                                .rounded(to: 2))
            ])
        ]
        return cells
    }
}
