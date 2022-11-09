//
//  WelcomePresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.07.22.
//

import Foundation

protocol PresentationLogic {
    func presentInitialData()
}

final class WelcomeScreenPresenter {
    weak var viewController: DisplayLogic?
}

extension WelcomeScreenPresenter: PresentationLogic {
    func presentInitialData() {
        self.viewController?.displayData()
    }
}
