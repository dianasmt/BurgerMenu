//
//  ListViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.09.22.
//

import UIKit

class ListViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    // MARK: - Properties
    
    // MARK: - Outlets
    private lazy var listOfDepartmentsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.separatorStyle = .singleLine
        table.register(DepartmentTableViewCell.self, forCellReuseIdentifier: DepartmentTableViewCell.className)
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .customYellow
        listOfDepartmentsTableView.tableHeaderView = searchController.searchBar
    }
}
