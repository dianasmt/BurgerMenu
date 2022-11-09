//
//  ErrorReportViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08/09/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import MessageUI

protocol ErrorReportDisplayLogic: AnyObject {
}

final class ErrorReportViewController: BaseViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate, ErrorReportDisplayLogic {    
    
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "error_report_error_report"
        static let describeTheProblem = "error_report_describe_the_problem"
        static let sendErrorReport = "error_report_send_button"
        static let emailRecepient = ["support@andersenbank.com"]
        static let emailSubject = "error_report_error_report"
        static let emailEnter = "error_report_enter_your_email"
        static let emailLabel = "error_report_email"
        static let myContactEmail = "error_report_my_contact_email"
    }
    
    // MARK: - Properties
    var router: ErrorReportRoutingLogic?
    var interactor: ErrorReportInteractorInput!
    private let disposeBag = DisposeBag()
    
    // MARK: - Override properties
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    // MARK: - Outlets
    private lazy var emailBottomBorder: UIView = {
        let emailBottomBorder = UIView()
        return emailBottomBorder
    }()
    
    private lazy var describeTheProblemLabel: UILabel = {
        let describeTheProblemLabel = UILabel()
        describeTheProblemLabel.text = .localString(stringKey: Const.describeTheProblem)
        describeTheProblemLabel.font = .fontSFProDisplay(type: .bold, size: 17)
        return describeTheProblemLabel
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.attributedPlaceholder = NSAttributedString(string: .localString(stringKey: Const.emailEnter),
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGray])
        emailTextField.font = .fontSFProDisplay(type: .regular, size: 14)
        emailTextField.returnKeyType = .go
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.delegate = self
        return emailTextField
    }()
    
    private lazy var describeYourProblemLabel: UILabel = {
        let describeYourProblemLabel = UILabel()
        describeYourProblemLabel.text = .localString(stringKey: Const.describeTheProblem)
        describeYourProblemLabel.font = .fontSFProDisplay(type: .regular, size: 14)
        describeYourProblemLabel.textColor = .customGray
        return describeYourProblemLabel
    }()
    
    private lazy var describeYourProblemTextView: UITextView = {
        let describeYourProblemTextView = UITextView()
        describeYourProblemTextView.enablesReturnKeyAutomatically = true
        describeYourProblemTextView.delegate = self
        describeYourProblemTextView.sizeToFit()
        describeYourProblemTextView.isScrollEnabled = false
        describeYourProblemTextView.layer.borderColor = UIColor.customGray.cgColor
        describeYourProblemTextView.layer.borderWidth = 1
        describeYourProblemTextView.layer.cornerRadius = 4
        describeYourProblemTextView.font = .fontSFProDisplay(type: .regular, size: 14)
        describeYourProblemTextView.textContainerInset = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 0)
        return describeYourProblemTextView
    }()
    
    private lazy var sendButton: UIButton = {
        let sendButton = UIButton()
        sendButton.setTitle(.localString(stringKey: Const.sendErrorReport), for: .normal)
        sendButton.titleLabel?.font = .fontSFProText(type: .bold, size: 16)
        sendButton.setTitleColor(.customBlack, for: .normal)
        sendButton.backgroundColor = .customYellow
        sendButton.layer.cornerRadius = 6
        return sendButton
    }()
    
    private lazy var charactersLeft: UILabel = {
        let charactersLeft = UILabel()
        charactersLeft.font = .fontRoboto(type: .regular, size: 12)
        charactersLeft.textColor = .customGray
        return charactersLeft
    }()
    
    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel()
        emailLabel.text = .localString(stringKey: Const.emailLabel)
        emailLabel.font = .fontRoboto(type: .regular, size: 14)
        emailLabel.textColor = .customGray
        emailLabel.isHidden = true
        return emailLabel
    }()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        registerForKeyboardNotifications()
        setupBindings()
        updateCharacterCount()
    }
    
    // MARK: - Methods
    private func registerForKeyboardNotifications() {
        self.view.rx
            .tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.view.endEditing(true)
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, notification in
                weakSelf.keyboardWillShow(notification: notification as NSNotification)
            })
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, notification in
                weakSelf.keyboardWillHide(notification: notification as NSNotification)
            })
            .disposed(by: disposeBag)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.sendButton.snp.updateConstraints { maker in
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15 + keyboardRectangle.height)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.sendButton.snp.updateConstraints { maker in
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        self.view.layoutIfNeeded()
    }
    
    private func setupBindings() {
        self.sendButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, value in
                let message = weakSelf.describeYourProblemTextView.text + .localString(stringKey: Const.myContactEmail) + (weakSelf.emailTextField.text ?? .empty)
                weakSelf.router?.navigateToMailComposerViewController(recepients: Const.emailRecepient,
                                                                      subject: .localString(stringKey: Const.titleLabelName),
                                                                      message: message,
                                                                      isHTML: false)
            })
            .disposed(by: self.disposeBag)
        
        self.emailTextField.rx.controlEvent(.editingDidBegin)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.emailLabel.isHidden = false
                weakSelf.emailTextField.attributedPlaceholder = NSAttributedString(string: .empty)
            })
            .disposed(by: self.disposeBag)
        
        self.emailTextField.rx.controlEvent([.editingDidEnd, .editingDidEndOnExit])
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                guard weakSelf.emailTextField.text?.isEmpty == true else { return }
                weakSelf.emailLabel.isHidden = true
                weakSelf.emailTextField.attributedPlaceholder = NSAttributedString(string: .localString(stringKey: Const.emailEnter),
                                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.customGray])
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupSubviews() {
        view.addSubview(sendButton)
        sendButton.snp.makeConstraints { maker in
            maker.centerX.equalTo(view)
            maker.height.equalTo(60)
            maker.width.equalTo(345)
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        
        view.addSubview(describeTheProblemLabel)
        describeTheProblemLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(20 * Constants.screenFactor)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(36 * Constants.screenFactor)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { maker in
            maker.top.equalTo(describeTheProblemLabel.snp.bottom).offset(34 * Constants.screenFactor)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(44 * Constants.screenFactor)
            maker.leading.trailing.equalToSuperview().inset(44 * Constants.screenFactor)
        }
        
        emailTextField.addSubview(emailBottomBorder)
        emailBottomBorder.backgroundColor = .customGray
        emailBottomBorder.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(38 * Constants.screenFactor)
            maker.height.equalTo(1 * Constants.screenFactor)
            maker.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(describeYourProblemLabel)
        describeYourProblemLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(141 * Constants.screenFactor)
            maker.height.equalTo(24 * Constants.screenFactor)
            maker.leading.equalToSuperview().inset(44 * Constants.screenFactor)
        }
        
        view.addSubview(describeYourProblemTextView)
        describeYourProblemTextView.snp.makeConstraints { maker in
            maker.top.equalTo(describeYourProblemLabel.snp.bottom).offset(2 * Constants.screenFactor)
            maker.centerX.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(44 * Constants.screenFactor)
        }
        
        view.addSubview(charactersLeft)
        charactersLeft.snp.makeConstraints { maker in
            maker.top.equalTo(describeYourProblemTextView.snp.bottom).offset(2 * Constants.screenFactor)
            maker.height.equalTo(16 * Constants.screenFactor)
            maker.trailing.equalToSuperview().inset(44 * Constants.screenFactor)
        }
        
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { maker in
            maker.bottom.equalTo(emailTextField.snp.top)
            maker.height.equalTo(18 * Constants.screenFactor)
            maker.leading.equalToSuperview().inset(44 * Constants.screenFactor)
        }
    }
    
    private func updateCharacterCount() {
        let charactersCount = describeYourProblemTextView.text.count
        charactersLeft.text = "\(0 + charactersCount) / 999"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == describeYourProblemTextView) {
            return textView.text.count + (text.count - range.length) <= 999
        }
        return false
    }
    
    override func setupTheme(theme: Theme) {
        super.setupTheme(theme: theme)
        describeYourProblemTextView.backgroundColor = theme.colors.textViewBackgroundColor
        describeTheProblemLabel.textColor = theme.colors.customLabel
        emailTextField.textColor = theme.colors.customLabel
        describeYourProblemTextView.textColor = theme.colors.customLabel
    }
}

extension ErrorReportViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
