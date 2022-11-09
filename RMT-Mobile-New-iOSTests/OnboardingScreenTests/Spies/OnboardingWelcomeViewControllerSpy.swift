//
//  OnboardingWelcomeViewControllerSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 19.09.2022.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class OnboardingWelcomeViewControllerSpy: OnboardingWelcomePresentorOutput {    
    private(set) var displayDataCalled = false
    private(set) var displayedPages: [PagesDataSource] = []
        
    func displayData(pages: [PagesDataSource]) {
        displayDataCalled = true
        displayedPages = pages
    }
}
