//
//  ChangeLangConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 4.08.22.
//

import Foundation

final class ChangeLangConfigurator {
    static func createModule() -> ChangeLangViewController {
        let viewController = ChangeLangViewController()
        let interactor = ChangeLangInteractor()
        let presenter = ChangeLangPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
