//
//  DepartmentInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import CoreLocation

protocol DepartmentInteractorInput {
    func presentInitialData()
    func handleShowHideButton(shouldOpen: Bool)
    func handleTapOnWeekday(day: Int)
    func passData(department: DepartmentsResponse)
}

protocol DepartmentInteractorOutput {
    func displaySections(sections: [DepartmentSectionDataSource])
    func displayHeaders(main: DepartmentInfoHeaderModel, secondary: WorkScheduleHeaderModel)
    func updateDepartmentInfoHeaderView(model: DepartmentInfoHeaderModel)
    func updateWorkingHoursHeaderView(model: WorkScheduleHeaderModel)
    func updateNavigationTitle(title: String)
}

protocol DepartmentDataStore {
    var department: DepartmentsResponse! { get set }
}

final class DepartmentInteractor: DepartmentDataStore {
    var presenter: DepartmentInteractorOutput!
    var department: DepartmentsResponse!
    private enum Const {
        static let monday = "monday_short"
        static let tuesday = "tuesday_short"
        static let wednesday = "wednesday_short"
        static let thursday = "thursday_short"
        static let friday = "friday_short"
        static let saturday = "saturday_short"
        static let sunday = "sunday_short"
    }
}

extension DepartmentInteractor: DepartmentInteractorInput {
    func passData(department: DepartmentsResponse) {
        self.department = department
    }
    // MARK: - Display initial data
    func presentInitialData() {
        self.presenter.updateNavigationTitle(title: getNavigationTitle())
        
        let sections = [
            DepartmentSectionDataSource(items: []),
            DepartmentSectionDataSource(items: []),
            DepartmentSectionDataSource(items: getServicesByType(type: .primary)),
            DepartmentSectionDataSource(items: getServicesByType(type: .additional))
        ]
        
        self.presenter.displaySections(sections: sections)
        self.presenter.displayHeaders(main: getDepartmentInfoHeaderModel(shouldOpen: false), secondary: getWorkScheduleModel(on: Date.currentWeekdayIndex))
    }
    
    // MARK: - Handle taps
    func handleShowHideButton(shouldOpen: Bool) {
        let model = getDepartmentInfoHeaderModel(shouldOpen: shouldOpen)
        presenter.updateDepartmentInfoHeaderView(model: model)
    }
    
    func handleTapOnWeekday(day: Int) {
        let model = getWorkScheduleModel(on: day)
        presenter.updateWorkingHoursHeaderView(model: model)
    }
    
    // MARK: - Helper functions
    private func getNavigationTitle() -> String {
        switch department.type {
        case DepartmentType.terminal:
            return "ATMs_name_terminal"
        case DepartmentType.atm:
            return "ATMs_name_atm"
        default:
            return "ATMs_name_department"
        }
        return "ATMs_name_department"
    }
    
    private func getDepartmentInfoHeaderModel(shouldOpen: Bool) -> DepartmentInfoHeaderModel {
        let infoHandler = DepartmentInfoHandler(department: department)
        let name = infoHandler.getName()
        let address = department.address
        let status = department.status
        let distance = infoHandler.getDistance()
        let workingHours = getWorkingHoursByDay(index: Date.currentWeekdayIndex)
        return DepartmentInfoHeaderModel(name: name, address: address, distance: distance, status: status, workingHours: workingHours, showWorkSchedule: shouldOpen)
    }
    
    private func getWorkScheduleModel(on day: Int) -> WorkScheduleHeaderModel {
        let weekdays = [Const.monday, Const.tuesday, Const.wednesday, Const.thursday, Const.friday, Const.saturday, Const.sunday]
        let dataSource = WeekdaysSectionDataSource(items: weekdays.enumerated()
                                                    .map {
            WeekdayCellModel(title: .localString(stringKey: $1), isUnderlined: $0 == Date.currentWeekdayIndex, isSelected: $0 == day)
        })
        
        return WorkScheduleHeaderModel(dataSource: dataSource, workingHours: getWorkingHoursByDay(index: day))
    }
    
    private func getServicesByType(type: ATMServiceType) -> [ServiceCellModel] {
        let services: [Service]
        
        switch type {
        case .primary:
            services = department.services.filter {
                $0.type == ATMServiceType.primary
            }
        case .additional:
            services = department.services.filter {
                $0.type == ATMServiceType.additional
            }
        }
        
        return services
            .map {
                ServiceCellModel(reuseIdentifier: DepartmentInfoTableViewCell.className,
                                 title: String.localString(stringKey: "ATMs_services_\($0.name.rawValue.lowercased())")
                                    .capitalizingFirstLetter(),
                                 image: "ATMs_\($0.name.rawValue.lowercased())")
            }
    }
    
    private func getWorkingHoursByDay(index: Int) -> String {
        let currentSchedule = department.schedule[index]
        return "\(currentSchedule.from) - \(currentSchedule.to)"
    }
}
