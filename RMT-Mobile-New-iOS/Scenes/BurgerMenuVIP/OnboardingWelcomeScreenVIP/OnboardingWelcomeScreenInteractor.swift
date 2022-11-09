//
//  OnboardingWelcomeScreenInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Aibek on 26.07.2022.
//

import UIKit

protocol OnboardingWelcomeInteractorInput {
}

protocol OnboardingWelcomeInteractorOutput {
}

final class OnboardingWelcomeInteractor {
    var presenter: OnboardingWelcomeInteractorOutput!
    let pages: [PageModel] = [PageModel(imageName: "onboarding_screen_image_one",
                                        label: "Lorem ipsum dolor sit amet",
                                        extralabel: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
                              PageModel(imageName: "onboarding_screen_image_two",
                                        label: "Lorem ipsum dolor sit amet",
                                        extralabel: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
                              PageModel(imageName: "onboarding_screen_image_three",
                                        label: "Lorem ipsum dolor sit amet",
                                        extralabel: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
                              PageModel(imageName: "onboarding_screen_image_four",
                                        label: "Lorem ipsum dolor sit amet",
                                        extralabel: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.")]
}

extension OnboardingWelcomeInteractor: OnboardingWelcomeInteractorInput {
}


