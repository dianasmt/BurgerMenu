//
//  ATMsSegmentedInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 20.09.22.
//

import Foundation
import RxSwift

protocol ATMsSegmentedInteractorInput {
    func loadDepartments()
}

protocol ATMsSegmentedInteractorOutput {
    func displayDepartments(for departments: [DepartmentsResponse])
}

final class ATMsSegmentedInteractor {
    let disposeBag = DisposeBag()
    var presenter: ATMsSegmentedInteractorOutput
    var networkService: ATMsNetworkServiceLogic
    
    init(presenter: ATMsSegmentedInteractorOutput, networkService: ATMsNetworkServiceLogic) {
        self.presenter = presenter
        self.networkService = networkService
    }
}

extension ATMsSegmentedInteractor: ATMsSegmentedInteractorInput {
    func loadDepartments() {
        networkService.getDepartments()
            .startWith([])
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { weakSelf, departments in
                weakSelf.presenter.displayDepartments(for: departments)
            })
            .disposed(by: disposeBag)
    }
}
