//
//  ListInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 20.09.22.
//

import Foundation

protocol ListInteractorInput {
    func filterDepartments(searchText: String)
    func setUpTableView()
    func setDepartments(departments: [DepartmentsResponse])
}

protocol ListInteractorOutput {
    func displayDepartments(departments: [DepartmentsResponse])
    func setUpTableView()
}

final class ListInteractor {
    var presenter: ListInteractorOutput!
    private var arrayOfDepartments: [DepartmentsResponse] = []
}

extension ListInteractor: ListInteractorInput {
    func setUpTableView() {
        presenter.setUpTableView()
    }
    
    func setDepartments(departments: [DepartmentsResponse]) {
        self.arrayOfDepartments = departments
        self.presenter.displayDepartments(departments: departments)
    }
    
    func filterDepartments(searchText: String) {
        if searchText.isEmpty {
            self.presenter.displayDepartments(departments: arrayOfDepartments)
        } else {
            let filteredarrayOfDepartments = arrayOfDepartments.filter {
                $0.address.lowercased().starts(with: searchText.lowercased())
            }
            self.presenter.displayDepartments(departments: filteredarrayOfDepartments)
        }
    }
}
