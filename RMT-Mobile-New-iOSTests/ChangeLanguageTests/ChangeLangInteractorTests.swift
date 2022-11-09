//
//  ChangeLangInteractorTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class ChangeLangInteractorTests: XCTestCase {
    var sut: ChangeLangInteractor!
    var presenterSpy: ChangeLangPresenterSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ChangeLangInteractor()
        presenterSpy = ChangeLangPresenterSpy()
        
        sut?.presenter = presenterSpy
    }
    
    func testPresentInitialDataPresenter() throws {
        // When
        sut.presentInitialData()
        // Then
        XCTAssert(presenterSpy.displayLanguagesCalled, "presentInitialData() should ask the presenter to display the languages")
        XCTAssertEqual(presenterSpy.languages[0].items.count, 2)
    }
    
    func testTypesOfCells() throws {
        let languages: [Languages] = [.rus, .eng]
        // When
        sut.presentInitialData()
        // Then
        for (indexSection, language) in languages.enumerated() {
            XCTAssertEqual(language, presenterSpy.languages[0].items[indexSection].language)
        }
    }
    
    func testChangingLanguage() {
        let expectation = XCTNSNotificationExpectation(name: Notification.Name.languageChanged)
        sut.changeLanguage(language: .rus)
        wait(for: [expectation], timeout: 3.0)
    }
}
