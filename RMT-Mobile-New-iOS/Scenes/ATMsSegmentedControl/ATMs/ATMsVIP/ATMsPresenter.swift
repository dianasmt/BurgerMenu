//
//  ATMsPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 6.09.22.
//

import Foundation
import GoogleMaps

protocol ATMsPresentorOutput: AnyObject {
    func displayData(sections: [ATMsSectionDataSource])
    func displayPopUp(with model: ATMDetailsPopUpViewModel, data: DepartmentsResponse)
    func displayDepartmentsForPins(departments: [DepartmentsResponse])
}

final class ATMsPresenter {
    weak var viewController: ATMsPresentorOutput?
}

extension ATMsPresenter: ATMsInteractorOutput {
    func displaySections(sections: [ATMsSectionDataSource]) {
        self.viewController?.displayData(sections: sections)
    }
    
    func displayPopUp(with model: ATMDetailsPopUpViewModel, data: DepartmentsResponse) {
        self.viewController?.displayPopUp(with: model, data: data)
    }
    
    func displayDepartments(departments: [DepartmentsResponse]) {
        self.viewController?.displayDepartmentsForPins(departments: departments)
    }
}
