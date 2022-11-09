//
//  ATMsConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 6.09.22.
//

import Foundation

final class ATMsConfigurator: BaseConfigurator {
    @discardableResult
    static func build(with viewController: ATMsViewController) -> ATMsViewController {
        let viewController = ATMsViewController()
        let interactor = ATMsInteractor()
        let presenter = ATMsPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
