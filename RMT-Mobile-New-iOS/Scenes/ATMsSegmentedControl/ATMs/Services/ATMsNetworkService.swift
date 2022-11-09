//
//  ATMsNetworkService.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 7.09.22.
//

import Foundation
import Moya
import RxSwift

protocol ATMsNetworkServiceLogic {
    func getDepartments() -> Observable<[DepartmentsResponse]>
}

class ATMsNetworkService: ATMsNetworkServiceLogic {
    private let provider = MoyaProvider<ATMsService>()
    
    func getDepartments() -> Observable<[DepartmentsResponse]> {
        return provider.rx
            .request(.getDepartmants)
            .asObservable()
            .filterSuccessfulStatusAndRedirectCodes()
            .map([DepartmentsResponse].self)
    }
}
