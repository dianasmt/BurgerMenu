//
//  DepartmentConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation

final class DepartmentConfigurator: BaseDelegateConfigurator {
    @discardableResult
    static func build(with viewController: DepartmentViewController, delegate: WelcomeScreenDelegate?) -> DepartmentViewController {
        let viewController = DepartmentViewController()
        let interactor = DepartmentInteractor()
        let presenter = DepartmentPresenter(viewController: viewController)
        let router = DepartmentRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        viewController.router = router
        router.viewController = viewController
        router.delegate = delegate
        
        return viewController
    }
}
