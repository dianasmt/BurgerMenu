//
//  MenuInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 25.07.22.
//

import UIKit

protocol MenuInteractorInput {
    func presentInitialData()
    func clickOnNumber(number: String)
}

protocol MenuInteractorOutput {
    func displaySections(sections: [SectionDataSource])
    func displayPhoneDialer(number: String)
}

final class MenuInteractor {
    enum Const {
        static let ATMsImageName = "burger_menu_atm"
        static let currencyImageName = "burger_menu_currency"
        static let phoneImageName = "burger_menu_phone"
        static let errorImageName = "burger_menu_error"
        static let languageImageName = "burger_menu_language"
        static let modeImageName = "burger_menu_mode"
        static let empty = ""
        static let ATMs = "burger_menu_ATMs"
        static let currency = "burger_menu_exchange_rates"
        static let phonePoland = "4800"
        static let descriptionPoland = "burger_menu_number_information"
        static let phone = "+48 560 375 222"
        static let description = "burger_menu_international_number_information"
        static let sendreport = "burger_menu_submit_bug_report"
        static let language = "burger_menu_language"
        static let darkMode = "burger_menu_mode"
        static let languageRU = "burger_menu_indicator_language"
    }
    var presenter: MenuInteractorOutput?
}

extension MenuInteractor: MenuInteractorInput {
    func presentInitialData() {
        let sections = [
            SectionDataSource(items: [
                CellModel(reuseIdentifier: ImageTitleTableViewCell.className, title: Const.ATMs, subTitle: Const.empty, image: Const.ATMsImageName, type: .ATMs),
                CellModel(reuseIdentifier: ImageTitleTableViewCell.className, title: Const.currency, subTitle: Const.empty, image: Const.currencyImageName, type: .exchangeRates)
            ]),
            SectionDataSource(items: [
                CellModel(reuseIdentifier: ImageTitleTableViewCell.className, title: Const.phonePoland, subTitle: Const.descriptionPoland, image: Const.phoneImageName, type: .polandNumber),
                CellModel(reuseIdentifier: ImageTitleTableViewCell.className, title: Const.phone, subTitle: Const.description, image: Const.phoneImageName, type: .number),
                CellModel(reuseIdentifier: ImageTitleTableViewCell.className, title: Const.sendreport, subTitle: Const.empty, image: Const.errorImageName, type: .errorReport)
            ]),
            SectionDataSource(items: [
                ChangeLangCellModel(reuseIdentifier: ChangeLangTableViewCell.className, title: Const.language, image: Const.languageImageName, language: Const.languageRU, type: .language)
            ]),
            SectionDataSource(items: [
                SwitchCellModel(reuseIdentifier: SwitchTableViewCell.className, title: Const.darkMode, image: Const.modeImageName, switcherIsOn: false, type: .darkMode)
            ])
        ]
        self.presenter?.displaySections(sections: sections)
    }
    
    func clickOnNumber(number: String) {
        let plainNumber = number.replacingOccurrences(of: " ", with: String.empty)
        presenter?.displayPhoneDialer(number: plainNumber)
    }
}
