//
//  DepartmentViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class DepartmentViewController: BaseViewController {
    
    // MARK: - Consts
    private enum Const {
        static var titleLabelName = "ATMs_name_department"
        static let popularServices = "popular_services"
        static let additionalServices = "additional_services"
    }
    
    // MARK: - Properties
    var router: DepartmentRoutingLogic?
    var interactor: DepartmentInteractorInput?
    private var isWorkingHoursHeaderViewOpen = false
    private let disposeBag = DisposeBag()
    private let defaults = UserDefaults.standard
    
    // MARK: - Override properties
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    // MARK: - Outlets
    private lazy var departmentTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = .zero
        }
        table.register(DepartmentTableHeaderView.self, forHeaderFooterViewReuseIdentifier: DepartmentTableHeaderView.className)
        table.register(DepartmentWorkingHoursHeaderView.self, forHeaderFooterViewReuseIdentifier: DepartmentWorkingHoursHeaderView.className)
        table.register(DepartmentTableSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: DepartmentTableSectionHeaderView.className)
        table.register(DepartmentInfoTableViewCell.self, forCellReuseIdentifier: DepartmentInfoTableViewCell.className)
        return table
    }()
    
    private lazy var mainHeaderView: DepartmentTableHeaderView = {
        let headerView = DepartmentTableHeaderView()
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var workScheduleHeaderView: DepartmentWorkingHoursHeaderView = {
        let headerView = DepartmentWorkingHoursHeaderView()
        headerView.delegate = self
        return headerView
    }()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        interactor?.presentInitialData()
    }
    
    // MARK: - Methods
    private func setUpTableView() {
        view.addSubview(departmentTableView)
        departmentTableView.frame = view.bounds
        departmentTableView.delegate = self
    }
}

extension DepartmentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return mainHeaderView
        case 1:
            return workScheduleHeaderView
        case 2:
            let headerView = DepartmentTableSectionHeaderView(offset: .top)
            headerView.fill(title: .localString(stringKey: Const.popularServices))
            return headerView
        case 3:
            let headerView = DepartmentTableSectionHeaderView(offset: .regular)
            headerView.fill(title: .localString(stringKey: Const.additionalServices))
            return headerView
        default:
            return UITableViewHeaderFooterView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            if isWorkingHoursHeaderViewOpen {
                return UITableView.automaticDimension
            } else {
                return 0
            }
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0
    }
}

extension DepartmentViewController: DepartmentPresentorOutput {
    func displayData(sections: [DepartmentSectionDataSource]) {
        let dataSource = RxTableViewSectionedReloadDataSource<DepartmentSectionDataSource>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
                cell.fill(with: item)
                return cell
            })
        
        Observable.just(sections)
            .bind(to: departmentTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func displayHeaders(main: DepartmentInfoHeaderModel, secondary: WorkScheduleHeaderModel) {
        mainHeaderView.fill(with: main)
        workScheduleHeaderView.fill(with: secondary)
    }
    
    func updateDepartmentInfoHeaderView(model: DepartmentInfoHeaderModel) {
        mainHeaderView.fill(with: model)
        departmentTableView.reloadSections([1], animationStyle: .fade)
    }
    
    func updateWorkingHoursHeaderView(model: WorkScheduleHeaderModel) {
        workScheduleHeaderView.fill(with: model)
    }
    
    func updateNavigationTitle(title: String) {
           Const.titleLabelName = title
       }
    
    func passData(department: DepartmentsResponse) {
        interactor?.passData(department: department)
    }
}

extension DepartmentViewController: DepartmentHeaderViewDelegate {
    func didTapShowWorkingScheduleButton() {
        isWorkingHoursHeaderViewOpen.toggle()
        interactor?.handleShowHideButton(shouldOpen: isWorkingHoursHeaderViewOpen)
    }
}

extension DepartmentViewController: WorkingHoursHeaderViewDelegate {
    func didChooseWeekday(day: Int) {
        interactor?.handleTapOnWeekday(day: day)
    }
}
