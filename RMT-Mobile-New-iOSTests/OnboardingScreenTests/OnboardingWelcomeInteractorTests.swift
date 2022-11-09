//
//  OnboardingWelcomeInteractorTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 19.09.2022.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class OnboardingWelcomeInteractorTests: XCTestCase {
    var sut: OnboardingWelcomeInteractor!
    var presenterSpy: OnboardingWelcomePresenterSpy!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = OnboardingWelcomeInteractor()
        presenterSpy = OnboardingWelcomePresenterSpy()
        
        sut?.presenter = presenterSpy
    }

    func testPresentInitialDataPresenter() throws {
        // When
        sut.presentInitialData()
        // Then
        XCTAssert(presenterSpy.displaySectionsCalled,
                  "presentInitialData() should ask the presenter to display the Pages")
        XCTAssertEqual(presenterSpy.pages.count, 1)
    }
}
