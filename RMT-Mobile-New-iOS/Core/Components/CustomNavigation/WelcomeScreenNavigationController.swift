//
//  WelcomeScreenNC.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 05/08/2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol WelcomeScreenDelegate: AnyObject {
    func loadBurgerMenu()
    func loadRegistration()
    func loadCurrencyExchange()
    func loadChangeLang()
    func loadATMs()
    func loadUserRequest()
    func loadErrorReport()
    func loadMailComposer(recepients: [String], subject: String, message: String, isHTML: Bool)
    func loadDepartment(department: DepartmentsResponse)
}

final class WelcomeScreenNavigationController: CustomNavigationController {
    // MARK: - Consts
    enum Const {
        static let mapTitle = "ATMs_segmented_controller_map"
        static let listTitle = "ATMs_segmented_controller_list"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWelcomeScreen()
    }
    
    // MARK: - Methods
    private func loadWelcomeScreen() {
        let welcomeScreenVC = WelcomeScreenConfigurator.build(
            with: WelcomeScreenViewController(),
            delegate: self
        )
        self.loadController(with: welcomeScreenVC)
    }
}

// MARK: - WelcomeScreenDelegate
extension WelcomeScreenNavigationController: WelcomeScreenDelegate {
    
    func loadChangeLang() {
        let changeLangVC = ChangeLangConfigurator.createModule()
        self.loadController(with: changeLangVC)
    }
    
    func loadBurgerMenu() {
        let burgerVC = MenuConfigurator.build(with: MenuViewController(), delegate: self)
        self.loadController(with: burgerVC)
    }
    
    func loadRegistration() {
        let registrationVC = OnboardingWelcomeConfigurator.build(with: OnboardingWelcomeViewController(), delegate: self)
        self.loadController(with: registrationVC)
    }
    
    func loadCurrencyExchange() {
        let currencyExchangeVC = CurrencyExchangeConfigurator.build(with: .init())
        self.loadController(with: currencyExchangeVC)
    }
    
    func loadATMs() {
        let mapVC = ATMsConfigurator.build(with: ATMsViewController(), delegate: self)
        mapVC.title = String.localString(stringKey: Const.mapTitle)
        let listVC = ListConfigurator.build(with: ListViewController())
        listVC.title = String.localString(stringKey: Const.listTitle)
        
        let segmentedViewController = ATMsSegmentedController([mapVC, listVC])
        self.loadController(with: segmentedViewController)
        self.closeControllers(classNames: [UserRequestViewController.className])
    }
    
    func loadUserRequest() {
        let userRequestVC = UserRequestConfigurator.build(with: .init(), delegate: self)
        self.loadController(with: userRequestVC)
    }
    
    func loadErrorReport() {
        let errorReportVC = ErrorReportConfigurator.build(with: ErrorReportViewController(), delegate: self)
        self.loadController(with: errorReportVC)
    }
    
    func loadMailComposer(recepients: [String], subject: String, message: String, isHTML: Bool) {
        let loadMailController = MailComposerViewController(recepients: recepients, subject: subject, message: message, isHTML: isHTML)
        self.present(loadMailController, animated: true)
    }
    
    func loadDepartment(department: DepartmentsResponse) {
        let departmentVC = DepartmentConfigurator.build(with: .init(), delegate: self)
        departmentVC.router?.passData(department: department)
        self.loadController(with: departmentVC)
    }
}
