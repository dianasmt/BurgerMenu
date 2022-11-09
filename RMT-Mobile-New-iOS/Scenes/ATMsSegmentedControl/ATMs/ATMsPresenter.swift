//
//  ATMsPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 6.09.22.
//

import Foundation
import RxSwift

protocol ATMsPresentorOutput: AnyObject {
    func displayData(sections: [ATMsSectionDataSource])
    func displayPins(departments: [DepartmentsResponce])
    func displayPopUp(with model: ATMDetailsPopUpViewModel)
}

final class ATMsPresenter {
    weak var viewController: ATMsPresentorOutput?
}

extension ATMsPresenter: ATMsInteractorOutput {
    func displayDepartments(for departments: [DepartmentsResponce]) {
        self.viewController?.displayPins(departments: departments)
    }
    
    func displaySections(sections: [ATMsSectionDataSource]) {
        self.viewController?.displayData(sections: sections)
    }
    
    func displayPopUp(with model: ATMDetailsPopUpViewModel) {
        self.viewController?.displayPopUp(with: model)
    }
}
