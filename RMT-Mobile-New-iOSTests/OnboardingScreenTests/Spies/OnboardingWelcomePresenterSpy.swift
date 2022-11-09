//
//  OnboardingWelcomePresenterSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 19.09.2022.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class OnboardingWelcomePresenterSpy: OnboardingWelcomeInteractorOutput {    
    
    private(set) var displaySectionsCalled = false
    private(set) var pages: [PagesDataSource] = []
    
    func displayData(pages: [PagesDataSource]) {
        displaySectionsCalled = true
        self.pages = pages
    }
}
