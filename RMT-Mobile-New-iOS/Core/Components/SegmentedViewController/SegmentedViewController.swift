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
    
    // MARK: - Outlets
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segmentTitles())
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.fontSFProText(type: .semibold, size: 14)], for: .normal)
        return control
    }()
    
    // MARK: - Properties
    private(set) var segmentViewControllers: [UIViewController] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    public init(_ viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.segmentViewControllers = viewControllers
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpVC()
        self.setUpControl()
    }
    
    // MARK: - Methods
    private func setUpVC() {
        let viewControllers = self.segmentViewControllers
        viewControllers.forEach {
            $0.view.frame = self.view.bounds
            self.addChild($0)
            self.view.addSubview($0.view)
        }
    }
    
    private func setUpControl() {
        self.view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(32)
            make.leading.equalToSuperview().offset(15 * Constants.screenFactor)
            make.trailing.equalToSuperview().offset(-15 * Constants.screenFactor)
        }
    }
    
    func switchingVC(index: Int) {
        let viewControllers = self.segmentViewControllers
        
        viewControllers.enumerated().forEach { indexVC, vc in
            vc.view.isHidden = (indexVC != index)
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
    
    override func setupTheme(theme: Theme) {
        super.setupTheme(theme: theme)
        segmentedControl.backgroundColor = theme.colors.controlViewBackgroundColor
        segmentedControl.tintColor = theme.colors.customLabel
    }
}
