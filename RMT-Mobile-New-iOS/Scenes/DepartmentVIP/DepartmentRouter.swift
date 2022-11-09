//
//  DepartmentRouter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.09.2022.
//

import Foundation

protocol DepartmentRoutingLogic: AnyObject {
    func navigateToATMs()
    func passData(department: DepartmentsResponse)
}

final class DepartmentRouter {
    weak var viewController: DepartmentViewController?
    weak var delegate: WelcomeScreenDelegate?
}

extension DepartmentRouter: DepartmentRoutingLogic {
    func navigateToATMs() {
        self.delegate?.loadATMs()
    }
    
    func passData(department: DepartmentsResponse) {
        self.viewController?.interactor.passData(department: department)
    }
}
