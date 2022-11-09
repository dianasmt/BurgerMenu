//
//  WelcomeScreenConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.07.22.
//

import Foundation

final class WelcomeScreenConfigurator: BaseDelegateConfigurator {
    @discardableResult
    static func build(
        with viewController: WelcomeScreenViewController,
        delegate: WelcomeScreenDelegate?
    ) -> WelcomeScreenViewController {
        let presenter = WelcomeScreenPresenter()
        let interactor = WelcomeScreenInteractor()
        let router = WelcomeScreenRouter()
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.delegate = delegate
        
        return viewController
    }
}
