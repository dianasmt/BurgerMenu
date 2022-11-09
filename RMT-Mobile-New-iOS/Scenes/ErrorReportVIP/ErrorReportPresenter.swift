//
//  ErrorReportPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08/09/2022.
//

import Foundation

protocol ErrorReportPresentationLogic: AnyObject {
}

final class ErrorReportPresenter {
    weak var viewController: ErrorReportDisplayLogic?
}

extension ErrorReportPresenter: ErrorReportPresentationLogic {
}
