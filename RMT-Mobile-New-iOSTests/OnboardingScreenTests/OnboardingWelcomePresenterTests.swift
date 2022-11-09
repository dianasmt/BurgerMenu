//
//  OnboardingWelcomePresenterTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 19.09.2022.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class OnboardingWelcomePresenterTests: XCTestCase {
    
    var viewControllerSpy: OnboardingWelcomeViewControllerSpy!
    var sut: OnboardingWelcomePresenter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        viewControllerSpy = OnboardingWelcomeViewControllerSpy()
        sut = OnboardingWelcomePresenter(viewController: viewControllerSpy)
    }
    
    func testDisplayDataCalledByPresenter() throws {
        
        // When
        sut.displayData(pages: [])
        // Then
        XCTAssert(viewControllerSpy.displayDataCalled,
                  "displaySections() should ask the view controller to display data")
    }
}
