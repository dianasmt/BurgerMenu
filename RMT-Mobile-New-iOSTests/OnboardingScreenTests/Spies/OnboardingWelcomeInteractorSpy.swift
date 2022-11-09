//
//  OnboardingWelcomeInteractorSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 19.09.2022.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class OnboardingWelcomeInteractorSpy: OnboardingWelcomeInteractorInput {
    private(set) var presentInitialDataCalled = false
    
    func presentInitialData() {
        presentInitialDataCalled = true
    }
}
