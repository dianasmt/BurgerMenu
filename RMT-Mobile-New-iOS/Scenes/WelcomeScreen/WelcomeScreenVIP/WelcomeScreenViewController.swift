///
//  WelcomeScreenViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.07.22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class WelcomeScreenViewController: BaseViewController {
    
    // MARK: - Consts
    private enum Consts {
        static let logoImage = UIImage(named: "welcome_screen_logo")
        static let signIn = "welcome_screen_login_button_title"
        static let register = "welcome_screen_registration_button_title"
        static let burgerMenu = UIImage(named: "welcome_screen_burger_menu")?.withRenderingMode(.alwaysOriginal)
        static let ru = "Ru"
        static let en = "En"
    }
    
    // MARK: - Outlets
    private lazy var logo = UIImageView()
    
    private lazy var signInButton: UIButton = {
        let signInButton = UIButton(type: .system)
        signInButton.clipsToBounds = true
        signInButton.backgroundColor = .customYellow
        signInButton.contentMode = .scaleAspectFill
        signInButton.layer.cornerRadius = 6
        signInButton.setTitle(.localString(stringKey: Consts.signIn), for: .normal)
        signInButton.setTitleColor(.customBlack, for: .normal)
        signInButton.titleLabel?.font = .fontSFProText(type: .bold, size: 16)
        return signInButton
    }()
    
    private lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.clipsToBounds = true
        registerButton.contentMode = .scaleAspectFill
        registerButton.layer.cornerRadius = 6
        registerButton.setTitle(.localString(stringKey: Consts.register), for: .normal)
        registerButton.titleLabel?.font = .fontSFProText(type: .bold, size: 16)
        registerButton.layer.borderWidth = 2
        return registerButton
    }()
    
    private lazy var rusLanguageButton: LanguageButton = {
        let chooseRu = LanguageButton(with: .rus)
        chooseRu.setTitle(Consts.ru, for: .normal)
        return chooseRu
    }()
    
    private lazy var engLanguageButton: LanguageButton = {
        let chooseEn = LanguageButton(with: .eng)
        chooseEn.setTitle(Consts.en, for: .normal)
        return chooseEn
    }()
    
    private lazy var languageMenuStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.rusLanguageButton, self.engLanguageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: - Override properties
    override var navigationBarItem: NavigationBarItemType { return .view(self.languageMenuStackView) }
    override var isRightButtonHidden: Bool { return false }
    override var rightNavBarButtonImage: UIImage? { return Consts.burgerMenu }
    override var rightButtonHandler: (() -> Void)? { self.router?.navigate }
    
    // MARK: - Properties
    var router: RoutingLogic?
    var interactor: BusinessLogic?
    private let disposeBag = DisposeBag()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupBindings()
        
       NotificationCenter.default.rx
            .notification(.languageChanged)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.updateUI()
            })
            .disposed(by: self.disposeBag)
    }
    @objc func changingLanguage() {
        self.updateUI()
    }
    
    // MARK: - Methods
    private func setupSubviews() {
        view.addSubview(logo)
        logo.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-70 * Constants.screenFactor)
            maker.width.equalTo(233 * Constants.screenFactor)
            maker.height.equalTo(142 * Constants.screenFactor)
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { maker in
            maker.top.greaterThanOrEqualTo(self.logo.snp.bottom).priority(.high)
            maker.leading.equalToSuperview().offset(15)
            maker.trailing.equalToSuperview().inset(15)
            maker.height.equalTo(60)
        }

        view.addSubview(registerButton)
        registerButton.snp.makeConstraints { maker in
            maker.top.equalTo(signInButton.snp.bottom).offset(15)
            maker.leading.equalToSuperview().offset(15)
            maker.trailing.equalToSuperview().inset(15)
            maker.height.equalTo(60)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
    }
    
    private func setupBindings() {
        signInButton.rx.tap
            .subscribe(onNext: { print("Sign In") })
            .disposed(by: self.disposeBag)
        
        registerButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.router?.startRegistration()
            })
            .disposed(by: self.disposeBag)
        
        let chooseRuEvent = self.rusLanguageButton.rx
            .tap
            .asObservable()
            .withUnretained(self)
            .map { $0.0.rusLanguageButton.language }
        
        let chooseEnEvent = self.engLanguageButton.rx
            .tap
            .asObservable()
            .withUnretained(self)
            .map { $0.0.engLanguageButton.language }
        
        Observable.merge(chooseRuEvent, chooseEnEvent)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, language in
                Languages.current = language
                weakSelf.updateUI()
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(.languageChanged)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.updateUI()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func updateUI() {
        let buttons = self.languageMenuStackView.arrangedSubviews as? [LanguageButton]
        buttons?.forEach { $0.updateUI() }
        signInButton.setTitle(.localString(stringKey: Consts.signIn), for: .normal)
        registerButton.setTitle(.localString(stringKey: Consts.register), for: .normal)
    }
    
    override func setupTheme(theme: Theme) {
        super.setupTheme(theme: theme)
        logo.image = theme.welcomePageLogo
        registerButton.setTitleColor(theme.colors.registerButtonTitleColor, for: .normal)
        registerButton.layer.borderColor = theme.colors.registerButtonBorderColor.cgColor
    }
}
