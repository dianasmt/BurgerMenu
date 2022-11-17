//
//  OnboardingWelcomeScreenConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 02.08.2022.
//

import Foundation

final class OnboardingWelcomeConfigurator: BaseDelegateConfigurator {
    static func build(with viewController: OnboardingWelcomeViewController, delegate:
    WelcomeScreenDelegate?) -> OnboardingWelcomeViewController {
        let interactor = OnboardingWelcomeInteractor()
        let presenter = OnboardingWelcomePresenter(viewController: viewController)
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        
        return viewController
    }
}
