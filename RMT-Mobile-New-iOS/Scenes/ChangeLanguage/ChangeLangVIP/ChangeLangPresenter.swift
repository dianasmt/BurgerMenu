//
//  ChangeLangPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 4.08.22.
//

import Foundation

protocol ChangeLangPresentorOutput: AnyObject {
    func displayData(languages: [LanguageDataSource])
}

final class ChangeLangPresenter {
    weak var viewController: ChangeLangPresentorOutput?
}

extension ChangeLangPresenter: ChangeLangInteractorOutput {
    func displayLanguages(languages: [LanguageDataSource]) {
        self.viewController?.displayData(languages: languages)
    }
}
