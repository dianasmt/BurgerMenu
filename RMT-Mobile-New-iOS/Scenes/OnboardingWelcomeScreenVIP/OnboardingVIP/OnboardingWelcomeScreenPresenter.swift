//
//  OnboardingWelcomeScreenPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 24.07.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol OnboardingWelcomePresentorOutput: AnyObject {
    func displayData(pages: [PagesDataSource])
}

final class OnboardingWelcomePresenter {
    weak var viewController: OnboardingWelcomePresentorOutput?
    init(viewController: OnboardingWelcomePresentorOutput) {
        self.viewController = viewController
    }
}

extension OnboardingWelcomePresenter: OnboardingWelcomeInteractorOutput {
    func displayData(pages: [PagesDataSource]) {
        self.viewController?.displayData(pages: pages)
    }
}
