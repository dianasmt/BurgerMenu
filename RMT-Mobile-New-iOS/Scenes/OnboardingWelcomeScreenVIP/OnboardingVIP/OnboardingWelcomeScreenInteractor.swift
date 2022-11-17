//
//  OnboardingWelcomeScreenInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 26.07.2022.
//

import UIKit

protocol OnboardingWelcomeInteractorInput {
    func presentInitialData()
}

protocol OnboardingWelcomeInteractorOutput {
    func displayData(pages: [PagesDataSource])
}

final class OnboardingWelcomeInteractor {
    enum Const {
        static let screenImageOne = "onboarding_screen_image_one"
        static let screenImageTwo = "onboarding_screen_image_two"
        static let screenImageThree = "onboarding_screen_image_three"
        static let screenImageFour = "onboarding_screen_image_four"
        
        static let labelText = "Lorem ipsum dolor sit amet"
        static let extraLabelText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    }
    var presenter: OnboardingWelcomeInteractorOutput?
}

extension OnboardingWelcomeInteractor: OnboardingWelcomeInteractorInput {
    func presentInitialData() {
        let pages = [
            PagesDataSource(items: [
                PageModel(reuseIdentifier: PageCell.className,
                          imageName: Const.screenImageOne,
                          label: Const.labelText,
                          extralabel: Const.extraLabelText),
                PageModel(reuseIdentifier: PageCell.className,
                          imageName: Const.screenImageTwo,
                          label: Const.labelText,
                          extralabel: Const.extraLabelText),
                PageModel(reuseIdentifier: PageCell.className,
                          imageName: Const.screenImageThree,
                          label: Const.labelText,
                          extralabel: Const.extraLabelText),
                PageModel(reuseIdentifier: PageCell.className,
                          imageName: Const.screenImageFour,
                          label: Const.labelText,
                          extralabel: Const.extraLabelText)
            ])
        ]
        self.presenter?.displayData(pages: pages)
    }
}
