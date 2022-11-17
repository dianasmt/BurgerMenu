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
    func handlePinTap(pin: GMSMarker)
    func setDepartments(departments: [DepartmentsResponse])
    func didSelectService(service: NameService)
    func displayPopup(for department: DepartmentsResponse)
}

protocol ATMsInteractorOutput {
    func displaySections(sections: [ATMsSectionDataSource])
    func displayPopUp(with model: ATMDetailsPopUpViewModel, data: DepartmentsResponse)
    func displayDepartments(departments: [DepartmentsResponse])
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
    var presenter: ATMsInteractorOutput?
    private var selectedServices = Set<NameService>()
    private var arrayOfDepartments: [DepartmentsResponse] = []
}

extension ATMsInteractor: ATMsInteractorInput {
    
    func setDepartments(departments: [DepartmentsResponse]) {
        self.arrayOfDepartments = departments
        self.presenter?.displayDepartments(departments: departments)
    }
    
    func presentInitialData() {
        let ATMsSections = [
            ATMsSectionDataSource(title: Const.popularRequest,
                                  items: [ATMsCollectionModel(title: Const.transfer, image: Const.imageNameTransfer, nameService: .transfer),
                                          ATMsCollectionModel(title: Const.pay, image: Const.imageNamePay, nameService: .pay),
                                          ATMsCollectionModel(title: Const.withdraw, image: Const.imageNameWithdraw, nameService: .withdraw),
                                          ATMsCollectionModel(title: Const.replenish, image: Const.imageNameReplenish, nameService: .deposit),
                                          ATMsCollectionModel(title: Const.currency, image: Const.imageNameCurrency, nameService: .currencyExchange),
                                          ATMsCollectionModel(title: Const.withoutCard, image: Const.imageNameWithoutCard, nameService: .depositWithoutCard)]),
            ATMsSectionDataSource(title: Const.workSchedule,
                                  items: [ATMsCollectionModel(title: Const.weekend, image: Const.imageNameWeekend, nameService: .closed),
                                          ATMsCollectionModel(title: Const.openNow, image: Const.imageNameOpen, nameService: .open),
                                          ATMsCollectionModel(title: Const.aroundTheClock, image: Const.imageName24, nameService: .open)]),
            ATMsSectionDataSource(title: Const.additionaly,
                                  items: [ATMsCollectionModel(title: Const.ramp, image: Const.imageNameRamp, nameService: .ramp),
                                          ATMsCollectionModel(title: Const.exoticCurrency, image: Const.imageNameExotic, nameService: .exoticCurrencyExchange),
                                          ATMsCollectionModel(title: Const.consultation, image: Const.imageNameConsult, nameService: .consultation),
                                          ATMsCollectionModel(title: Const.insurance, image: Const.imageNameInsurance, nameService: .insurance)])
        ]
        self.presenter?.displaySections(sections: ATMsSections)
    }
    
    func handlePinTap(pin: GMSMarker) {
        let netwotkService = ATMsNetworkService()
        netwotkService.getDepartments()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { weakSelf, departments in
                if let department = departments.first(where: {
                    $0.coordinates == "\(pin.position.latitude), \(pin.position.longitude)"
                }) {
                    let model = weakSelf.getPopUpViewModel(for: department, at: pin.position)
                    weakSelf.presenter?.displayPopUp(with: model, data: department)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func displayPopup(for department: DepartmentsResponse) {
        let coordinates = department.coordinates.components(separatedBy: ", ")
        guard coordinates.count == 2, let latitude = Double(coordinates[0]), let longitude = Double(coordinates[1]) else {
                  return
              }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let model = getPopUpViewModel(for: department, at: location)
        presenter?.displayPopUp(with: model, data: department)
    }
    
    private func getPopUpViewModel(for department: DepartmentsResponse, at coordinates: CLLocationCoordinate2D) -> ATMDetailsPopUpViewModel {
        let infoHandler = DepartmentInfoHandler(department: department)
        let name = infoHandler.getName()
        let address = department.address
        let currentSchedule = infoHandler.getCurrentWorkSchedule(includeDayName: true)
        let status = department.status
        let atmServices = department.services
        let services = atmServices.map {
            String.localString(stringKey: "ATMs_services_\($0.name.rawValue.lowercased())")
        }
        let dataSource = [
            ATMServicesSectionDataSource(items:
                                            atmServices.map {
                                                ATMServicesCollectionViewCellModel(imageName: "ATMs_\($0.name.rawValue.lowercased())")
                                            }
                                        )
        ]
        let distance = infoHandler.getDistance()
        let model = ATMDetailsPopUpViewModel(name: name, address: address, workSchedule: currentSchedule, status: status, services: services, servicesDataSource: dataSource, distance: distance)
        return model
    }
    
    func filter() -> [DepartmentsResponse] {
        guard !selectedServices.isEmpty else { return arrayOfDepartments }
        
        var filteredarrayOfDepartments: [DepartmentsResponse] = []
        
        var flag = true
        for department in arrayOfDepartments {
            for nameService in selectedServices {
                if !(department.services.contains(where: { $0.name == nameService })) {
                    flag = false
                }
            }
            if flag {
                filteredarrayOfDepartments.append(department)
            }
            flag = true
        }
        for nameService in selectedServices {
            for department in arrayOfDepartments {
                if department.status.rawValue == nameService.rawValue {
                    filteredarrayOfDepartments.append(department)
                }
            }
        }
        return filteredarrayOfDepartments
    }
}

extension ATMsInteractor: PullUpATMsServiceDelegate {
    func didSelectService(service: NameService) {
        if selectedServices.contains(service) {
            selectedServices.remove(service)
        } else {
            selectedServices.insert(service)
        }
        self.presenter?.displayDepartments(departments: self.filter())
    }
}
