//
//  OnboardingWelcomeViewControllerTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 19.09.2022.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class OnboardingWelcomeViewControllerTests: XCTestCase {
    
    // MARK: - Test LifeCycle
    var sut: OnboardingWelcomeViewController!
    var interactorSpy: OnboardingWelcomeInteractorSpy!
    
    override func setUpWithError() throws {
        super.setUp()
        interactorSpy = OnboardingWelcomeInteractorSpy()
        sut = OnboardingWelcomeViewController()
        
        sut.interactor = interactorSpy
    }
    
    func testShouldPresentInitialDataWhenViewDidLoad() throws {
        // When
        sut.viewDidLoad()
        // Then
        XCTAssert(interactorSpy.presentInitialDataCalled,
                  "Should present initial data when view is loaded")
    }
}
