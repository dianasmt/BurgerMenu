//
//  OnboardingWelcomeScreenConfigurator.swift
//  RMT-Mobile-New-iOS
//
//  Created by Aibek on 02.08.2022.
//

import Foundation

final class OnboardingWelcomeConfigurator: BaseConfigurator {
    static func build(with viewController: OnboardingWelcomeViewController) -> OnboardingWelcomeViewController {
        let interactor = OnboardingWelcomeInteractor()
        let presenter = OnboardingWelcomePresenter(viewController: viewController)
        let router = OnboardingWelcomeRouter()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        viewController.router = router
        
        return viewController
    }
}
