//
//  MenuRouter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 25.07.22.
//

import Foundation

protocol MenuRoutingLogic: AnyObject {
    func navigateToCurrencyExchange()
    func navigateToChangeLang()
    func navigateToATMs()
    func navigateToRequestLocation()
    func navigateToErrorReport()
}

final class MenuRouter {
    weak var viewController: MenuViewController?
    weak var delegate: WelcomeScreenDelegate?
}

extension MenuRouter: MenuRoutingLogic {
    func navigateToCurrencyExchange() {
        self.delegate?.loadCurrencyExchange()
    }
    
    func navigateToChangeLang() {
        self.delegate?.loadChangeLang()
    }

    func navigateToATMs() {
        self.delegate?.loadATMs()
    }
    
    func navigateToRequestLocation() {
        self.delegate?.loadUserRequest()
    }
    
    func navigateToErrorReport() {
        self.delegate?.loadErrorReport()
    }
}
