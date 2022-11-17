//
//  WelcomeInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.07.22.
//

import Foundation

protocol BusinessLogic {
    func presentInitialData()
}

final class WelcomeScreenInteractor {
    var presenter: PresentationLogic?
}

extension WelcomeScreenInteractor: BusinessLogic {
    func presentInitialData() {
        presenter?.presentInitialData()
    }
}
