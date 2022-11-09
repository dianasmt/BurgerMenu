//
//  DepartmentInfoHandler.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 22.09.2022.
//

import Foundation

final class DepartmentInfoHandler {
    private let department: DepartmentsResponse
    private enum Const {
        static let departmentName = "ATMs_name_department"
        static let atmName = "ATMs_name_atm"
        static let terminalName = "ATMs_name_terminal"
        
        static let monday = "monday_short"
        static let tuesday = "tuesday_short"
        static let wednesday = "wednesday_short"
        static let thursday = "thursday_short"
        static let friday = "friday_short"
        static let saturday = "saturday_short"
        static let sunday = "sunday_short"
        
        static let kilometers = "kilometers_short"
        static let meters = "meters_short"
    }
    
    init(department: DepartmentsResponse) {
        self.department = department
    }
    
    func getName() -> String {
        var name = String.empty
        let atmName = department.name
        switch department.type {
        case DepartmentType.department:
            name = String.localString(stringKey: Const.departmentName) + " №\(atmName)"
        case DepartmentType.atm:
            name = String.localString(stringKey: Const.atmName) + " №\(atmName)"
        case DepartmentType.terminal:
            name = String.localString(stringKey: Const.terminalName) + " №\(atmName)"
        default:
            name = "\(atmName)"
        }
        return name
    }
    
    func getDistance() -> String? {
        var distanceText: String?
        let stringCoordintes = department.coordinates.components(separatedBy: ", ")
        if let latitude = Double(stringCoordintes[0]), let longitude = Double(stringCoordintes[1]) {
            if let distance = LocationService(viewController: ATMsViewController()).getDistance(to: (latitude, longitude)) {
                if distance > 1000 {
                    distanceText = "\(distance/1000) " + String.localString(stringKey: Const.kilometers)
                } else {
                    distanceText = "\(distance) " + String.localString(stringKey: Const.meters)
                }
            }
        }
        return distanceText
    }
    
    func getCurrentWorkSchedule(includeDayName: Bool) -> String {
        guard let currentSchedule = department.schedule.first(where: {
            $0.day.rawValue == String.currentWeekday.uppercased()
        }) else {
            return ""
        }
        
        if includeDayName  {
            var dayName = String.empty
            switch currentSchedule.day {
            case Weekday.monday:
                dayName = String.localString(stringKey: Const.monday)
            case Weekday.tuesday:
                dayName = String.localString(stringKey: Const.tuesday)
            case Weekday.wednesday:
                dayName = String.localString(stringKey: Const.wednesday)
            case Weekday.thursday:
                dayName = String.localString(stringKey: Const.thursday)
            case Weekday.friday:
                dayName = String.localString(stringKey: Const.friday)
            case Weekday.saturday:
                dayName = String.localString(stringKey: Const.saturday)
            default:
                dayName = String.localString(stringKey: Const.sunday)
            }
            return dayName.lowercased() + ": \(currentSchedule.from) - \(currentSchedule.to)"
        } else {
            return "\(currentSchedule.from) - \(currentSchedule.to)"
        }
    }
}
