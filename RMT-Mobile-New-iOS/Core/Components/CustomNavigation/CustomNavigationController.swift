//
//  CustomNC.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 04/08/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum NavigationBarItemType {
    case view(UIView)
    case backButton
}

protocol ViewProtocol: AnyObject {
    var navigationBarItem: NavigationBarItemType { get }
    var titleLabel: String? { get }
    var leftNavBarButtonTitle: String? { get }
    var leftNavBarButtonImage: String? { get }
    var isHeaderHidden: Bool { get }
    var isRightButtonHidden: Bool { get }
    var rightNavigationButtonTitle: String { get }
    var rightNavBarButtonImage: UIImage? { get }
    var rightButtonHandler: (() -> Void)? { get }
    var isProgressBarHidden: Bool { get }
}

class CustomNavigationController: UIViewController, BaseViewControllerDelegate {
    
    // MARK: - Consts
    private enum Consts {
        static let backButton = UIImage(named: "back_button_image")
    }
    
    // MARK: - Outlets
    private lazy var progressBarView: UIView = {
        let progView = UIView()
        return progView
    }()

    private lazy var statusBarView: UIView = {
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusbarView = UIView()
        statusbarView.frame.size.height = statusBarHeight
        return statusbarView
    }()
    
    private lazy var welcomeScreenNavigation: UIView = {
        let welcomeScreenNavigation = UIView()
        return welcomeScreenNavigation
    }()
    
    private lazy var welcomeScreenNavigationBottomBorder: UIView = {
        let welcomeScreenNavigationBottomBorder = UIView()
        return welcomeScreenNavigationBottomBorder
    }()
    
    private lazy var customTitle: UILabel = {
        let customTitle = UILabel()
        customTitle.text = .empty
        customTitle.font = .fontSFProText(type: .semibold, size: 17)
        customTitle.textAlignment = .center
        return customTitle
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        let backButtonImage = Consts.backButton
        backButton.setImage(backButtonImage, for: .normal)
        return backButton
    }()
    
    private lazy var leftViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    private lazy var rightNavigationButton: UIButton = {
        let rightNavigationButton = UIButton(type: .system)
        rightNavigationButton.layer.cornerRadius = 4
        rightNavigationButton.setTitle(.empty, for: .normal)
        rightNavigationButton.setTitleColor(.customGray, for: .normal)
        rightNavigationButton.titleLabel?.font = .fontSFProText(type: .semibold, size: 17)
        return rightNavigationButton
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if themeProvider.theme == .dark {
            return .lightContent
        } else {
            return .default
        }
    }
    
    /// Main screen
    private let viewContentContainer = UIView()
    /// For controller changing
    private let contentNavigationContoller = UINavigationController()
    private var rightButtonHandler: (() -> Void)?
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupBindings()
    }
    
    // MARK: - Methods
    func loadController(with contentController: BaseViewController) {
        contentController.delegate = self
        self.contentNavigationContoller.pushViewController(contentController, animated: true)
    }
    
    func addProgressBar(with view: UIView) {
        self.progressBarView.addSubview(view)
        view.stretchLayout()
    }
    
    func updateUI(controller: BaseViewController) {
        self.customTitle.text = controller.titleLabel
        
        self.rightNavigationButton.setTitle(controller.rightNavigationButtonTitle, for: .normal)
        self.rightNavigationButton.setImage(controller.rightNavBarButtonImage, for: .normal)
        self.rightNavigationButton.isHidden = controller.isRightButtonHidden
        self.rightButtonHandler = controller.rightButtonHandler
        
        self.updateNavigateionBarItem(for: controller)
        self.updateConstraints(for: controller)
        
        self.welcomeScreenNavigationBottomBorder.isHidden = !controller.isProgressBarHidden
    }
    
    private func updateNavigateionBarItem(for controller: BaseViewController) {
        switch controller.navigationBarItem {
        case .view(let view):
            self.backButton.isHidden = true
            self.leftViewContainer.isHidden = false
            self.leftViewContainer.subviews.forEach { $0.removeFromSuperview() }
            self.leftViewContainer.addSubview(view)
            view.stretchLayout()
        case .backButton:
            self.leftViewContainer.isHidden = true
            self.backButton.isHidden = false
        }
    }
    
    private func updateConstraints(for controller: BaseViewController) {
        self.welcomeScreenNavigation.snp.updateConstraints { maker in
            maker.height.equalTo(controller.isHeaderHidden ? 0 : 60)
        }
        self.welcomeScreenNavigationBottomBorder.snp.updateConstraints { maker in
            maker.height.equalTo(controller.isHeaderHidden ? 0 : 0.5)
        }
        self.progressBarView.snp.updateConstraints { make in
            make.height.equalTo(controller.isProgressBarHidden ? 0 : 2.5)
        }
    }
    
    private func setupSubviews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(statusBarView.frame.height)
        }
        
        view.addSubview(welcomeScreenNavigation)
        welcomeScreenNavigation.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(60)
        }
        
        view.addSubview(viewContentContainer)
        viewContentContainer.addSubview(contentNavigationContoller.view)
        viewContentContainer.snp.makeConstraints { maker in
            maker.top.equalTo(welcomeScreenNavigation.snp.bottom)
            maker.bottom.leading.trailing.equalToSuperview()
        }
        
        contentNavigationContoller.isNavigationBarHidden = true
        contentNavigationContoller.view.snp.makeConstraints {maker in
            maker.top.equalTo(welcomeScreenNavigation.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        
        welcomeScreenNavigation.addSubview(welcomeScreenNavigationBottomBorder)
        welcomeScreenNavigationBottomBorder.snp.makeConstraints{ maker in
            maker.leading.trailing.bottom.equalTo(welcomeScreenNavigation)
            maker.height.equalTo(0.5)
        }
        
        welcomeScreenNavigation.addSubview(backButton)
        backButton.snp.makeConstraints { maker in
            maker.top.equalTo(welcomeScreenNavigation).offset(7.5)
            maker.leading.equalTo(welcomeScreenNavigation.snp.leading).offset(15)
            maker.height.equalTo(45)
            maker.width.equalTo(45)
        }
        
        welcomeScreenNavigation.addSubview(progressBarView)
        progressBarView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(welcomeScreenNavigation)
            make.height.equalTo(2.5)
        }
        
        welcomeScreenNavigation.addSubview(self.leftViewContainer)
        welcomeScreenNavigation.addSubview(self.customTitle)
        welcomeScreenNavigation.addSubview(self.rightNavigationButton)
        
        self.customTitle.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview()
        }
        
        self.leftViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.5)
            make.bottom.equalToSuperview().inset(7.5)
            make.leading.equalTo(15)
            make.width.equalTo(100 * Constants.screenFactor).priority(.high)
            make.trailing.equalTo(self.customTitle.snp.leading).inset(15)
        }
        
        self.rightNavigationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.5)
            make.bottom.equalToSuperview().inset(7.5)
            make.trailing.equalToSuperview().inset(15)
            make.leading.greaterThanOrEqualTo(self.customTitle.snp.trailing).offset(15)
        }
    }
    
    private func setupBindings() {
        themeProvider.register(observer: self)
        
        self.backButton.rx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.contentNavigationContoller.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
        
        self.rightNavigationButton.rx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.rightButtonHandler?()
            })
            .disposed(by: self.disposeBag)
    }
    
    func closeControllers(classNames: [String]) {
        let newControllers: [UIViewController] = self.contentNavigationContoller.viewControllers.filter { !classNames.contains($0.className) }
        self.contentNavigationContoller.setViewControllers(newControllers, animated: false)
    }
}

extension CustomNavigationController: Themeable {
    func setupTheme(theme: Theme) {
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = theme.colors.customBackgrounColor
        customTitle.textColor = theme.colors.customLabel
        statusBarView.backgroundColor = theme.colors.customBackgrounColor
        welcomeScreenNavigation.backgroundColor = theme.colors.customBackgrounColor
        welcomeScreenNavigationBottomBorder.backgroundColor = .customSeparator
    }
}
