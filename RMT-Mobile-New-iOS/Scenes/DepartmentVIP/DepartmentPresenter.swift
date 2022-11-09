//
//  DepartmentPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol DepartmentPresentorOutput: AnyObject {
    func displayData(sections: [DepartmentSectionDataSource])
    func displayHeaders(main: DepartmentInfoHeaderModel, secondary: WorkScheduleHeaderModel)
    func updateDepartmentInfoHeaderView(model: DepartmentInfoHeaderModel)
    func updateWorkingHoursHeaderView(model: WorkScheduleHeaderModel)
    func updateNavigationTitle(title: String)
}

final class DepartmentPresenter {
    weak var viewController: DepartmentPresentorOutput?
    init(viewController: DepartmentPresentorOutput) {
        self.viewController = viewController
    }
}

extension DepartmentPresenter: DepartmentInteractorOutput {
    func displaySections(sections: [DepartmentSectionDataSource]) {
        self.viewController?.displayData(sections: sections)
    }
    
    func displayHeaders(main: DepartmentInfoHeaderModel, secondary: WorkScheduleHeaderModel) {
        self.viewController?.displayHeaders(main: main, secondary: secondary)
    }
    
    func updateDepartmentInfoHeaderView(model: DepartmentInfoHeaderModel) {
        self.viewController?.updateDepartmentInfoHeaderView(model: model)
    }
    
    func updateWorkingHoursHeaderView(model: WorkScheduleHeaderModel) {
        self.viewController?.updateWorkingHoursHeaderView(model: model)
    }
    
    func updateNavigationTitle(title: String) {
           self.viewController?.updateNavigationTitle(title: title)
       }
}
