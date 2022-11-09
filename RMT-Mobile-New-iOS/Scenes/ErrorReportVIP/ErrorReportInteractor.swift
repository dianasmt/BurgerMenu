//
//  ErrorReportInteractor.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08/09/2022.
//

import UIKit

protocol ErrorReportInteractorInput {
}

final class ErrorReportInteractor {
    var presenter: ErrorReportPresentationLogic?
}

extension ErrorReportInteractor: ErrorReportInteractorInput {
}
