//
//  ErrorReportViewControllerSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 26/09/2022.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class ErrorReportViewControllerSpy: ErrorReportDisplayLogic {
    private(set) var displayDataCalled = false
    
    func displayData() {
        self.displayDataCalled = true
    }
}

