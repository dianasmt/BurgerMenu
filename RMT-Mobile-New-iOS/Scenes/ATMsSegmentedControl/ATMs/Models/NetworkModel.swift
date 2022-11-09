//
//  NetworkModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 7.09.22.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

struct DepartmentsResponse: Codable {
    let id: String
    let address: String
    let city: String
    let coordinates: String
    let name: String
    let schedule: [Schedule]
    let status: DepartmentStatus
    let type: DepartmentType
    let services: [Service]
    let zoneId: String
    let scheduleType: String?
}

struct Schedule: Codable {
    let day: Weekday
    let from: String
    let to: String
}

struct Service: Codable {
    let id: String
    let name: NameService
    let type: ATMServiceType
}

enum DepartmentType: String, Codable {
    case terminal = "TERMINAL"
    case atm = "ATM"
    case department = "DEPARTMENT"
}

enum DepartmentStatus: String, Codable {
    case open = "OPEN"
    case closed = "CLOSED"
}

enum Weekday: String, Codable {
    case monday = "MONDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
    case thursday = "THURSDAY"
    case friday = "FRIDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"
}

enum ATMServiceType: String, Codable {
    case primary = "PRIMARY"
    case additional = "ADDITIONAL"
}

struct DepartmentsDataSource {
    var items: [DepartmentsResponse]
}

extension DepartmentsDataSource: SectionModelType {
    init(original: DepartmentsDataSource, items: [DepartmentsResponse]) {
        self = original
        self.items = items
    }
}

enum NameService: String, Codable {
    case pay = "PAY"
    case transfer = "TRANSFER"
    case currencyExchange = "CURRENCY_EXCHANGE"
    case withdraw = "WITHDRAW"
    case deposit = "DEPOSIT"
    case exoticCurrencyExchange = "EXOTIC_CURRENCY_EXCHANGE"
    case ramp = "RAMP"
    case depositWithoutCard = "DEPOSIT_WITHOUT_CARD"
    case insurance = "INSURANCE"
    case consultation = "CONSULTATION"
    case open = "OPEN"
    case closed = "CLOSED" 
}
