//
//  ListPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 20.09.22.
//

import Foundation
import RxSwift

protocol ListPresentorOutput: AnyObject {
    func displayData(sections: Observable<[DepartmentsDataSource]>)
}

final class ListPresenter {
    weak var viewController: ListPresentorOutput?
    private var dataSourceObject = ReplaySubject<[DepartmentsDataSource]>.create(bufferSize: 1)
}

extension ListPresenter: ListInteractorOutput {
    func setUpTableView() {
        self.viewController?.displayData(sections: self.dataSourceObject.asObservable())
    }
    
    func displayDepartments(departments: [DepartmentsResponse]) {
        let departmentsDataSource = [DepartmentsDataSource(items: departments)]
        dataSourceObject.onNext(departmentsDataSource)
    }
}
