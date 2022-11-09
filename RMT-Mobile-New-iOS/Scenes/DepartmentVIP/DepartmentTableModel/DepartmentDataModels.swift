//
//  DepartmentDataModels.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 22.09.2022.
//

import Foundation

protocol DepartmentCellProtocol {
    var reuseIdentifier: String { get }
    var title: String { get }
    var image: String { get }
}

struct ServiceCellModel: DepartmentCellProtocol {
    var reuseIdentifier: String
    let title: String
    let image: String
}

struct DepartmentInfoHeaderModel {
    let name: String
    let address: String
    let distance: String?
    let status: DepartmentStatus
    let workingHours: String
    let showWorkSchedule: Bool
}

struct WorkScheduleHeaderModel {
    let dataSource: WeekdaysSectionDataSource
    let workingHours: String
}

protocol WeekdayCellProtocol {
    var title: String { get }
    var isUnderlined: Bool { get }
    var isSelected: Bool { get }
}

struct WeekdayCellModel: WeekdayCellProtocol {
    var title: String
    var isUnderlined: Bool
    var isSelected: Bool
}
