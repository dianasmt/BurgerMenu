//
//  ATMsSegmentedViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 20.09.22.
//

import Foundation
import UIKit
import RxSwift

protocol ATMsSegmentedControllerChildDelegate: AnyObject {
    func displayPopup(for department: DepartmentsResponse)
}

class ATMsSegmentedController: SegmentedViewController {
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "ATMs_title_menu"
        static let searchImagename = "ATMs_bank_search"
    }
    weak var childDelegate: ATMsSegmentedControllerChildDelegate?
    
    private let disposeBag = DisposeBag()
    var interactor: ATMsSegmentedInteractorInput!
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Const.searchImagename), for: .normal)
        button.contentMode = .center
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.customShadowGray.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.customShadowGray.cgColor
        return button
    }()
    
    private lazy var segmentBackgroundView = UIView()
    
    // MARK: - Override
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setUpSubview()
        self.interactor.loadDepartments()
        self.setupBindings()
        self.setUpBindingsButton()
    }
    
    private func setup() {
        let viewController = self
        let presenter = ATMsSegmentedPresenter()
        let interactor = ATMsSegmentedInteractor(presenter: presenter, networkService: ATMsNetworkService())
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func setUpSubview() {
        view.addSubview(segmentBackgroundView)
        segmentBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(segmentedControl).offset(20 * Constants.screenFactor)
        }
        
        view.bringSubviewToFront(segmentedControl)
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(segmentBackgroundView.snp.bottom).offset(10 * Constants.screenFactor)
            make.height.width.equalTo(40)
            make.leading.equalToSuperview().offset(15 * Constants.screenFactor)
        }
        
        for view in segmentViewControllers {
            (view as? ListViewController)?.parentDelegate = self
            if let mapVC = view as? ATMsViewController {
                self.childDelegate = mapVC
            }
        }
    }
    
    private func setupBindings() {
        segmentedControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .subscribe (onNext: { weakSelf, index in
                weakSelf.switchingVC(index: index)
                weakSelf.searchButton.isHidden = (index == 1)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setUpBindingsButton() {
        searchButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.switchingVC(index: 1)
                weakSelf.segmentedControl.selectedSegmentIndex = 1
                weakSelf.searchButton.isHidden = true
            })
            .disposed(by: self.disposeBag)
    }
    
    override func setupTheme(theme: Theme) {
        super.setupTheme(theme: theme)
        searchButton.backgroundColor = theme.colors.customBackgrounColor
        segmentBackgroundView.backgroundColor = theme.colors.customBackgrounColor
    }
}

extension ATMsSegmentedController: ATMsSegmentedPresentorOutput {
    func displayDepartments(departments: [DepartmentsResponse]) {
        self.segmentViewControllers.forEach { vc in
            (vc as? ATMsSegmentedPresentorOutput)?.displayDepartments(departments: departments)
        }
    }
}

extension ATMsSegmentedController: ATMsListParentViewControllerDelegate {
    func didSelectTableCell(with department: DepartmentsResponse) {
        switchingVC(index: 0)
        segmentedControl.selectedSegmentIndex = 0
        childDelegate?.displayPopup(for: department)
        searchButton.isHidden = false
    }
}
