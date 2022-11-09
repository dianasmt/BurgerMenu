//
//  CurrencyExchangePresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 11.08.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol CurrencyExchangePresentorOutput: AnyObject {
    func displayData(cells: [CurrencyDataSource])
}

final class CurrencyExchangePresenter {
    weak var viewController: CurrencyExchangePresentorOutput?
}
extension CurrencyExchangePresenter: CurrencyExchangeInteractorOutput {
    func displayCells(cells: [CurrencyDataSource]) {
        self.viewController?.displayData(cells: cells)
    }
}
