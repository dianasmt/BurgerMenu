//
//  ChangeLangInteracoreSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class ChangeLangInteractorSpy: ChangeLangInteractorInput {
    var presentInitialDataCalled = false
    
    func presentInitialData() {
        presentInitialDataCalled = true
    }
    
    func changeLanguage(language: Languages) { }
}
