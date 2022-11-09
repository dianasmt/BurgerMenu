//
//  ATMsInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 6.09.22.
//

import Foundation
import RxSwift
import GoogleMaps

protocol ATMsInteractorInput {
    func presentInitialData()
    func loadDepartments()
    func handlePinTap(pin: GMSMarker)
}

protocol ATMsInteractorOutput {
    func displaySections(sections: [ATMsSectionDataSource])
    func displayDepartments(for departments: [DepartmentsResponce])
    func displayPopUp(with model: ATMDetailsPopUpViewModel)
}

final class ATMsInteractor {
    enum Const {
        static let popularRequest = "ATMs_collection_header_requests"
        static let workSchedule =  "ATMs_collection_header_schedule"
        static let additionaly = "ATMs_collection_header_additionaly"
        
        static let imageNameTransfer = "ATMs_transfer"
        static let imageNamePay = "ATMs_pay"
        static let imageNameWithdraw = "ATMs_withdraw"
        static let imageNameReplenish = "ATMs_deposit"
        static let imageNameCurrency = "ATMs_currency_exchange"
        static let imageNameWithoutCard = "ATMs_deposit_without_card"
        static let imageNameWeekend = "ATMs_weekend"
        static let imageNameOpen = "ATMs_open"
        static let imageName24 = "ATMs_24"
        static let imageNameRamp = "ATMs_ramp"
        static let imageNameExotic = "ATMs_exotic_currency_exchange"
        static let imageNameConsult = "ATMs_consultation"
        static let imageNameInsurance = "ATMs_insurance"
        
        static let transfer = "ATMs_collection_requests_transfer"
        static let pay = "ATMs_collection_requests_pay"
        static let withdraw = "ATMs_collection_requests_withdraw"
        static let replenish = "ATMs_collection_requests_replenish"
        static let currency = "ATMs_collection_requests_exchange"
        static let withoutCard = "ATMs_collection_requests_without_card"
        static let weekend = "ATMs_collection_schedule_weekend"
        static let openNow = "ATMs_collection_schedule_open"
        static let aroundTheClock = "ATMs_collection_schedule_24"
        static let ramp = "ATMs_collection_additionaly_ramp"
        static let exoticCurrency = "ATMs_collection_additionaly_exotic"
        static let consultation = "ATMs_collection_additionaly_consult"
        static let insurance = "ATMs_collection_additionaly_insurance"
        
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
        
        static let atmOpen = "atm_status_open"
        static let atmClosed = "atm_status_closed"
        
        static let kilometers = "kilometers_short"
        static let meters = "meters_short"
    }
    
    let disposeBag = DisposeBag()
    var presenter: ATMsInteractorOutput!
}

extension ATMsInteractor: ATMsInteractorInput {
    func presentInitialData() {
        let ATMsSections = [
            ATMsSectionDataSource(title: Const.popularRequest,
                                  items: [ATMsCollectionModel(title: Const.transfer, image: Const.imageNameTransfer),
                                          ATMsCollectionModel(title: Const.pay, image: Const.imageNamePay),
                                          ATMsCollectionModel(title: Const.withdraw, image: Const.imageNameWithdraw),
                                          ATMsCollectionModel(title: Const.replenish, image: Const.imageNameReplenish),
                                          ATMsCollectionModel(title: Const.currency, image: Const.imageNameCurrency),
                                          ATMsCollectionModel(title: Const.withoutCard, image: Const.imageNameWithoutCard)]),
            ATMsSectionDataSource(title: Const.workSchedule,
                                  items: [ATMsCollectionModel(title: Const.weekend, image: Const.imageNameWeekend),
                                          ATMsCollectionModel(title: Const.openNow, image: Const.imageNameOpen),
                                          ATMsCollectionModel(title: Const.aroundTheClock, image: Const.imageName24)]),
            ATMsSectionDataSource(title: Const.additionaly,
                                  items: [ATMsCollectionModel(title: Const.ramp, image: Const.imageNameRamp),
                                          ATMsCollectionModel(title: Const.exoticCurrency, image: Const.imageNameExotic),
                                          ATMsCollectionModel(title: Const.consultation, image: Const.imageNameConsult),
                                          ATMsCollectionModel(title: Const.insurance, image: Const.imageNameInsurance)])
        ]
        self.presenter.displaySections(sections: ATMsSections)
    }
    
    func loadDepartments() {
        let netwotkService = ATMsNetworkService()
        netwotkService.getDepartments()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                   weakSelf, departments in
                   weakSelf.presenter.displayDepartments(for: departments)
               })
               .disposed(by: disposeBag)
    }
    
    func handlePinTap(pin: GMSMarker) {
        let netwotkService = ATMsNetworkService()
        netwotkService.getDepartments()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                   weakSelf, departments in
                if let department = departments.first(where: {
                    $0.coordinates == "\(pin.position.latitude), \(pin.position.longitude)"
                }) {
                    let model = weakSelf.getPopUpViewModel(for: department, at: pin.position)
                    weakSelf.presenter.displayPopUp(with: model)
                }
               })
               .disposed(by: disposeBag)
    }

    
    private func getPopUpViewModel(for department: DepartmentsResponce, at coordinates: CLLocationCoordinate2D) -> ATMDetailsPopUpViewModel {
        var name = String.empty
        if let atmName = department.name, let type = department.type {
            switch type {
            case DepartmentType.department.rawValue:
                name = String.localString(stringKey: Const.departmentName) + " №\(atmName)"
            case DepartmentType.atm.rawValue:
                name = String.localString(stringKey: Const.atmName) + " №\(atmName)"
            case DepartmentType.terminal.rawValue:
                name = String.localString(stringKey: Const.terminalName) + " №\(atmName)"
            default:
                name = "\(atmName)"
            }
        }
        
        var address = String.empty
        if let atmAddress = department.address {
            address = String.localString(stringKey: "atm_address_\(department.id!)")
        }

        var schedule = String.empty
        if let schedules = department.schedule {
            if let currentSchedule = schedules.first(where: {
                $0.day == String.currentWeekday.uppercased()
            }) {
                if let fromTime = currentSchedule.from, let toTime = currentSchedule.to {
                    switch currentSchedule.day {
                    case Weekday.monday.rawValue:
                        schedule = String.localString(stringKey: Const.monday)
                    case Weekday.tuesday.rawValue:
                        schedule = String.localString(stringKey: Const.tuesday)
                    case Weekday.wednesday.rawValue:
                        schedule = String.localString(stringKey: Const.wednesday)
                    case Weekday.thursday.rawValue:
                        schedule = String.localString(stringKey: Const.thursday)
                    case Weekday.friday.rawValue:
                        schedule = String.localString(stringKey: Const.friday)
                    case Weekday.saturday.rawValue:
                        schedule = String.localString(stringKey: Const.saturday)
                    default:
                        schedule = String.localString(stringKey: Const.sunday)
                    }
                    schedule += (": " + fromTime + " - " + toTime)
                }
            }
        }
        
        var statusText = String.empty
        var status: ATMStatus = .closed
        if let atmStatus = department.status {
            switch atmStatus {
            case ATMStatus.open.rawValue:
                statusText = Const.atmOpen
                status = .open
            default:
                statusText = Const.atmClosed
                status = .closed
            }
        }
        
        var services: [String] = []
        var dataSource: [ATMServicesSectionDataSource] = []
        if let atmServices = department.services {
            services = atmServices.map {
                String.localString(stringKey: "ATMs_services_\($0.name!.lowercased())")
            }
            
            dataSource = [
                ATMServicesSectionDataSource(items:
                                                atmServices.map {
                                                    ATMServicesCollectionViewCellModel(imageName: "ATMs_\($0.name!.lowercased())")
                                                }
                                            )
            ]
        }
        
        var distanceText: String?
        if let distance = getDistance(to: (coordinates.latitude, coordinates.longitude)) {
            if distance > 1000 {
                distanceText = "\(distance/1000) " + String.localString(stringKey: Const.kilometers)
            } else {
                distanceText = "\(distance) " + String.localString(stringKey: Const.meters)
            }
        }
        
        let model = ATMDetailsPopUpViewModel(name: name, address: address, workSchedule: schedule, statusText: statusText, status: status, services: services, servicesDataSource: dataSource, distance: distanceText)
        
        return model
    }
    
    private func getDistance(to coordinates: (Double, Double)) -> Int? {
        return LocationService().getDistance(to: (coordinates.0, coordinates.1))
    }
}

