//
//  ListViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.09.22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ATMsListParentViewControllerDelegate: AnyObject {
    func didSelectTableCell(with department: DepartmentsResponse)
}

class ListViewController: BaseViewController {
    weak var parentDelegate: ATMsListParentViewControllerDelegate?
    
    // MARK: - Consts
    enum Const {
        static let errorImageName = "ATMs_results_not_found"
        static let errortext = "ATMs_not_found"
        static let placeholder = "placeholder_for_searchbar"
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    var interactor: ListInteractorInput!
    
    // MARK: - Outlets
    private lazy var listOfDepartmentsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.register(DepartmentTableViewCell.self, forCellReuseIdentifier: DepartmentTableViewCell.className)
        return table
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = String.localString(stringKey: Const.placeholder)
        searchBar.sizeToFit()
        return searchBar
    }()
    
    private lazy var imageErrorView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Const.errorImageName)
        return imageView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .bold, size: 14)
        label.textColor = .black.withAlphaComponent(0.6)
        label.text = String.localString(stringKey: Const.errortext)
        return label
    }()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpError()
        self.setUpTableView()
    }
    
    // MARK: - Methods
    
    private func setUpTableView() {
        view.addSubview(listOfDepartmentsTableView)
        view.addSubview(searchBar)
        listOfDepartmentsTableView.backgroundColor = .clear
        listOfDepartmentsTableView.delegate = self
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalTo(5)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }
        listOfDepartmentsTableView.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        listOfDepartmentsTableView.keyboardDismissMode = .onDrag
        interactor.setUpTableView()
    }
    
    private func setUpImage() {
        view.addSubview(imageErrorView)
        let imageName = themeProvider.theme == .dark ? Const.errorImageName + "_dark" : Const.errorImageName
        imageErrorView.image = UIImage(named: imageName)
        imageErrorView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(65 * Constants.screenFactor)
            make.trailing.equalToSuperview().offset(-65 * Constants.screenFactor)
            make.top.equalToSuperview().offset(225 * Constants.screenFactor)
            make.bottom.equalToSuperview().offset(-255 * Constants.screenFactor)
        }
    }
    
    private func setUpErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.textColor = themeProvider.theme.colors.customLabel
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(imageErrorView.snp_bottomMargin).offset(80 * Constants.screenFactor)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setUpError() {
        setUpImage()
        setUpErrorLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ListViewController: ATMsSegmentedPresentorOutput {
    func displayDepartments(departments: [DepartmentsResponse]) {
        interactor.setDepartments(departments: departments)
    }
}

extension ListViewController: ListPresentorOutput {
    func displayData(sections: RxSwift.Observable<[DepartmentsDataSource]>) {
        let dataSource = RxTableViewSectionedReloadDataSource<DepartmentsDataSource>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: DepartmentTableViewCell.className, for: indexPath)
                cell.fill(with: item)
                return cell
            })
        sections
            .do(onNext: { [weak self] departments in
                let isEmpty = departments.first?.items.isEmpty ?? true
                self?.listOfDepartmentsTableView.isHidden = isEmpty
                self?.imageErrorView.isHidden = !isEmpty
                self?.errorLabel.isHidden = !isEmpty
            })
            .bind(to: listOfDepartmentsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
                listOfDepartmentsTableView.rx
                .modelSelected(DepartmentsResponse.self)
                .withUnretained(self)
                .subscribe(onNext: { weakSelf, department in
                    weakSelf.parentDelegate?.didSelectTableCell(with: department)
                })
                .disposed(by: disposeBag)
                }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.interactor.filterDepartments(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
