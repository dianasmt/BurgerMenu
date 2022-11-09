//
//  OnboardingWelcomeScreenPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Aibek on 24.07.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol OnboardingWelcomePresentorOutput: class {
}

final class OnboardingWelcomePresenter {
    weak var viewController: OnboardingWelcomePresentorOutput?
    
    init(viewController: OnboardingWelcomePresentorOutput) {
        self.viewController = viewController
    }
}

extension OnboardingWelcomePresenter: OnboardingWelcomeInteractorOutput {
}

    
