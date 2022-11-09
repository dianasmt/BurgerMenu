//
//  WelcomeScreenRouter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.07.22.
//

import Foundation

protocol RoutingLogic: AnyObject {
    func navigate()
    func startRegistration()
}

final class WelcomeScreenRouter{
    weak var viewController: DisplayLogic?
    weak var delegate: WelcomeScreenDelegate?
}

extension WelcomeScreenRouter: RoutingLogic {
    func navigate() {
        self.delegate?.loadBurgerMenu()
    }
    func startRegistration() {
        self.delegate?.loadRegistration()
    }
}
