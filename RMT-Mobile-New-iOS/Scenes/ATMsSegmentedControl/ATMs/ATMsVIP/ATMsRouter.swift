//
//  ATMsRouter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 21.09.22.
//

import Foundation

protocol ATMsViewRoutingLogic: AnyObject {
    func navigateToATMs()
    func navigateToDepartment(department: DepartmentsResponse)
}

final class ATMsRouter {
    weak var viewController: ATMsViewController?
    weak var delegate: WelcomeScreenDelegate?
}

extension ATMsRouter: ATMsViewRoutingLogic {
    func navigateToATMs() { }
    
    func navigateToDepartment(department: DepartmentsResponse) {
        self.delegate?.loadDepartment(department: department)
    }
}
