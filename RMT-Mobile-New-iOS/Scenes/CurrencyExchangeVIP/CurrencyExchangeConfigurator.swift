//
//  CurrencyExchangeConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 11.08.2022.
//

import Foundation

final class CurrencyExchangeConfigurator: BaseConfigurator {
    @discardableResult
    static func build(with viewController: CurrencyExchangeViewController) -> CurrencyExchangeViewController {
        let viewController = CurrencyExchangeViewController()
        let worker = CurrencyExchangeWorker(manager: CurrencyExchangeNetworkManager())
        let interactor = CurrencyExchangeInteractor(worker: worker)
        let presenter = CurrencyExchangePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }
}
