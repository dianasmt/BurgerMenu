//
//  ListConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 21.09.22.
//

import Foundation

final class ListConfigurator: BaseConfigurator {
    @discardableResult static func build(with viewController: ListViewController) -> ListViewController {
        let viewController = ListViewController()
        let interactor = ListInteractor()
        let presenter = ListPresenter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
}
