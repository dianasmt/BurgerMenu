//
//  PopupViewModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Islam Shamkhanov on 22.09.2022.
//

import Foundation

struct ATMDetailsPopUpViewModel {
    let name: String
    let address: String
    let workSchedule: String
    let status: DepartmentStatus
    let services: [String]
    let servicesDataSource: [ATMServicesSectionDataSource]
    let distance: String?
}
