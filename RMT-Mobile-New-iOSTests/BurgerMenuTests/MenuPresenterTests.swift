//
//  MenuPresenterTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 22.08.22.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class MenuPresenterTests: XCTestCase {
    var viewControllerSpy: MenuViewControllerSpy!
    var sut: MenuPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewControllerSpy = MenuViewControllerSpy()
        sut = MenuPresenter(viewController: viewControllerSpy)
    }

    func testDisplayDataCalledByPresenter() throws {
        // When
        sut.displaySections(sections: [])
        // Then
        XCTAssert(viewControllerSpy.displayDataCalled, "displaySections() should ask the view controller to display data")
    }
}
