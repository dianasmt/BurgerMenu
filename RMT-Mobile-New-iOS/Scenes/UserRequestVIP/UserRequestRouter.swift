//
//  UserRequestRouter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08.08.2022.
//

import Foundation

protocol UserRequestViewRoutingLogic: AnyObject {
    func navigateToATMs()
}

final class UserRequestRouter {
    weak var viewController: UserRequestViewController?
    weak var delegate: WelcomeScreenDelegate?
}

extension UserRequestRouter: UserRequestViewRoutingLogic {
    func navigateToATMs() {
        self.delegate?.loadATMs()
    }
}
