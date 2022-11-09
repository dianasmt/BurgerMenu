//
//  ErrorReportConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08/09/2022.
//

import Foundation

final class ErrorReportConfigurator: BaseDelegateConfigurator {
    @discardableResult
    static func build(
        with viewController: ErrorReportViewController, delegate: WelcomeScreenDelegate?
    ) -> ErrorReportViewController {
        let presenter = ErrorReportPresenter()
        let interactor = ErrorReportInteractor()
        let router = ErrorReportRouter()
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.delegate = delegate
        
        return viewController
    }
}
