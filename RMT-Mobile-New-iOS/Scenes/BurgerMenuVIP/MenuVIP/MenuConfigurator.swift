//
//  MenuConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 25.07.22.
//

import Foundation

final class MenuConfigurator: BaseDelegateConfigurator {
    @discardableResult
    static func build(with viewController: MenuViewController, delegate: WelcomeScreenDelegate?) -> MenuViewController {
        let viewController = MenuViewController()
        let interactor = MenuInteractor()
        let presenter = MenuPresenter(viewController: viewController)
        let router = MenuRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        viewController.router = router
        router.viewController = viewController
        router.delegate = delegate
        
        return viewController
    }
}
