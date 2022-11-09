//
//  UserRequestConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08.08.2022.
//

import Foundation

final class UserRequestConfigurator: BaseDelegateConfigurator {
    @discardableResult
    static func build(with viewController: UserRequestViewController, delegate: WelcomeScreenDelegate?) -> UserRequestViewController {
        let viewController = UserRequestViewController()
        let interactor = UserRequestInteractor()
        let presenter = UserRequestPresenter(viewController: viewController)
        let router = UserRequestRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        viewController.router = router
        router.viewController = viewController
        router.delegate = delegate
        
        return viewController
    }
}
