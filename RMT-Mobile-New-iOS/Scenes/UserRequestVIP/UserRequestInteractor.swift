//
//  UserRequestInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08.08.2022.
//

import UIKit

protocol UserRequestInteractorInput {
}

protocol UserRequestInteractorOutput {
}

final class UserRequestInteractor {
    var presenter: UserRequestInteractorOutput!

    enum Const {
        static let titleButtonKey = "onboarding_welcome_screen_continue_button_state_one"
        static let titleKey = "explanation_allow_access_to_your_location"
        static let descriptionKey = "explanation_access_to_your_location"
        static let imageName = "location_request_image_one"
    }
}

extension UserRequestInteractor: UserRequestInteractorInput {
}
