//
//  ATMsConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 6.09.22.
//

import Foundation

final class ATMsConfigurator: BaseDelegateConfigurator {
    @discardableResult
    static func build(with viewController: ATMsViewController, delegate: WelcomeScreenDelegate?) -> ATMsViewController {
        let viewController = ATMsViewController()
        let interactor = ATMsInteractor()
        let presenter = ATMsPresenter()
        let router = ATMsRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
        router.viewController = viewController
        router.delegate = delegate
        
        return viewController
    }
}
