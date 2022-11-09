//
//  ChangeLangPresenterTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class ChangeLangPresenterTests: XCTestCase {
    var viewControllerSpy: ChangeLangVCSpy!
    var sut: ChangeLangPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewControllerSpy = ChangeLangVCSpy()
        sut = ChangeLangPresenter()
        
        sut.viewController = viewControllerSpy
    }

    func testDisplayDataCalledByPresenter() throws {
        // When
        sut.displayLanguages(languages: [])
        // Then
        XCTAssert(viewControllerSpy.displayDataCalled, "displayLanguages() should ask the view controller to display data")
    }
}
