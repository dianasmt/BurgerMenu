//
//  ChangeLangVCTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class ChangeLangVCTests: XCTestCase {

    var sut: ChangeLangViewController!
    var interactorSpy: ChangeLangInteractorSpy!
    
    override func setUpWithError() throws {
        super.setUp()
        interactorSpy = ChangeLangInteractorSpy()
        sut = ChangeLangViewController()
        
        sut.interactor = interactorSpy
    }
    
    func testShouldPresentInitialDataWhenViewDidLoad() throws {
        // When
        sut.viewDidLoad()
        // Then
        XCTAssert(interactorSpy.presentInitialDataCalled, "Should present initial data when view is loaded")
    }
}
