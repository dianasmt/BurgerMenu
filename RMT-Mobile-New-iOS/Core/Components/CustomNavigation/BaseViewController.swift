//
//  PreviousScreenController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08/08/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol BaseViewControllerDelegate: AnyObject {
    func loadController(with contentController: BaseViewController)
    func updateUI(controller: BaseViewController)
}

class BaseViewController: UIViewController, ViewProtocol, Themeable {
    
    // MARK: - Properties
    var navigationBarItem: NavigationBarItemType { return .backButton }
    var isHeaderHidden: Bool { return false }
    var titleLabel: String? { return .empty }
    var rightNavigationButtonTitle: String { return .empty }
    var rightNavBarButtonImage: UIImage? { return nil }
    var leftNavBarButtonTitle: String? { return .empty }
    var leftNavBarButtonImage: String? { return .empty }
    var isRightButtonHidden: Bool { return true }
    var rightButtonHandler: (() -> Void)? { return nil }
    var isProgressBarHidden: Bool { return true }
    
    // MARK: - Delegate
    weak var delegate: BaseViewControllerDelegate?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        themeProvider.register(observer: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.delegate?.updateUI(controller: self)
    }
    
    func setupTheme(theme: Theme) {
        view.backgroundColor = theme.colors.customBackgrounColor
    }
}
