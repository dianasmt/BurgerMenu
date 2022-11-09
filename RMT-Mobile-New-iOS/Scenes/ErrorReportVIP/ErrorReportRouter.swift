//
//  ErrorReportRouter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08/09/2022.
//

import Foundation

protocol ErrorReportRoutingLogic: AnyObject {
    func navigateToMailComposerViewController(recepients: [String], subject: String, message: String, isHTML: Bool)
}

final class ErrorReportRouter {
    weak var viewController: ErrorReportDisplayLogic?
    weak var delegate: WelcomeScreenDelegate?
}

extension ErrorReportRouter: ErrorReportRoutingLogic {
    func navigateToMailComposerViewController(recepients: [String], subject: String, message: String, isHTML: Bool) {
        self.delegate?.loadMailComposer(recepients: recepients,
                                        subject: subject,
                                        message: message,
                                        isHTML: isHTML)
    }
}
