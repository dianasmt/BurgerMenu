//
//  SegmentViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 20.09.22.
//

import Foundation
import UIKit
import RxSwift

class SegmentedViewController: BaseViewController {
    
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "ATMs_title_menu"
    }
    
    // MARK: - Outlets
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentTitles())
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGreyColor
        control.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontSFProText(type: .semibold, size: 14)], for: .normal)
        return control
    }()
    
    // MARK: - Properties
    private var segmentViewControllers: [UIViewController] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    public init(_ viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.segmentViewControllers = viewControllers
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpVC()
        self.setUpControl()
        self.setupBindings()
    }
    
    // MARK: - Methods
    private func setUpVC() {
        let viewControllers = self.segmentViewControllers
        viewControllers.forEach {
            $0.view.frame = self.view.bounds
            self.view.addSubview($0.view)
        }
    }
    
    private func setUpControl() {
        self.view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(32)
            make.leading.equalToSuperview().offset(15 * Constants.screenFactor)
            make.trailing.equalToSuperview().offset(-15 * Constants.screenFactor)
        }
    }
    
    private func setupBindings() {
        segmentedControl.rx.selectedSegmentIndex
            .subscribe (onNext: { [weak self] index in
                self?.switchingVC(index: index)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func switchingVC(index: Int) {
        let viewControllers = self.segmentViewControllers
        
        viewControllers.enumerated().forEach { indexVC, vc in
            vc.view.isHidden = true
            if indexVC == index {
                vc.view.isHidden = false
            }
        }
    }
    
    private func segmentTitles() -> [String] {
        var segmentTitles: [String] = []
        for viewController in self.segmentViewControllers {
            if let title = viewController.title {
                segmentTitles.append(title)
            }
        }
        return segmentTitles
    }
}
