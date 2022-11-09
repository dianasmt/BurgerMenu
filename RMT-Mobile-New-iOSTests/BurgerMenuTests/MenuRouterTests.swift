//
//  MenuRouterTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class MenuRouterTests: XCTestCase {
    var sut: MenuRouter!
    var delegateSpy: DelegateSpy!

    override func setUpWithError() throws {
        super.setUp()
        sut = MenuRouter()
        delegateSpy = DelegateSpy()
        
        sut.delegate = delegateSpy
    }
    
    func testExample() throws {
        // When
        sut.navigateToChangeLang()
        // Then
        XCTAssert(delegateSpy.loadChangeLangCalled, "navigateToChangeLang() should ask the delegate to load ChangeLangVC")
    }
}
