//
//  BurgerMenuTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 19.08.22.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class MenuInteractorTests: XCTestCase {
    var sut: MenuInteractor!
    var presenterSpy: MenuPresenterSpy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MenuInteractor()
        presenterSpy = MenuPresenterSpy()
        
        sut?.presenter = presenterSpy
    }
    
    func testPresentInitialDataPresenter() throws {
        // When
        sut.presentInitialData()
        // Then
        XCTAssert(presenterSpy.displaySectionsCalled, "presentInitialData() should ask the presenter to display the sections")
        XCTAssertEqual(presenterSpy.sections.count, 4)
    }
    
    func testTypesOfCells() throws {
        let sectionsTypes: [[BurgerMenuCellType]] = [[.ATMs, .exchangeRates], [.polandNumber, .number, .errorReport], [.language], [.darkMode]]
        // When
        sut.presentInitialData()
        // Then
        for (indexSection, section) in sectionsTypes.enumerated() {
            for (indexItem, typeCell) in section.enumerated() {
                XCTAssertEqual(typeCell, presenterSpy.sections[indexSection].items[indexItem].type)
            }
        }
    }
}
