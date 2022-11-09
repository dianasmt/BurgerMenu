//
//  ChangeLangInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 4.08.22.
//

import Foundation
import UIKit

protocol ChangeLangInteractorInput {
    func presentInitialData()
    func changeLanguage(language: Languages)
}

protocol ChangeLangInteractorOutput {
    func displayLanguages(languages: [LanguageDataSource])
}

final class ChangeLangInteractor {
    enum Const {
        static let languageRU = "change_language_ru"
        static let languageENG = "change_language_eng"
        static let selectedLangImageName = "change_lang_selected"
    }
    var presenter: ChangeLangInteractorOutput!
}

extension ChangeLangInteractor: ChangeLangInteractorInput {
    func presentInitialData() {
        
        let languages = [
            LanguageDataSource(items: [
                LanguageModel(title: Const.languageRU, icon: Const.selectedLangImageName, language: .rus),
                LanguageModel(title: Const.languageENG, icon: Const.selectedLangImageName, language: .eng)
            ])
        ]

        self.presenter.displayLanguages(languages: languages)
    }
    
    func changeLanguage(language: Languages) {
        Languages.current = language
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
}
