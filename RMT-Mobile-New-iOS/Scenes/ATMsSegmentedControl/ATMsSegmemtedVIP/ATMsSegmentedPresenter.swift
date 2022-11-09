//
//  ATMsSegmentedPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 20.09.22.
//

import Foundation

protocol ATMsSegmentedPresentorOutput: AnyObject {
    func displayDepartments(departments: [DepartmentsResponse])
}

final class ATMsSegmentedPresenter {
    weak var viewController: ATMsSegmentedPresentorOutput?
}

extension ATMsSegmentedPresenter: ATMsSegmentedInteractorOutput {
    func displayDepartments(for departments: [DepartmentsResponse]) {
        self.viewController?.displayDepartments(departments: departments)
    }
}
