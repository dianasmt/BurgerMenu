//
//  MenuViewControllerTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 22.08.22.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class MenuViewControllerTests: XCTestCase {
    
    // MARK: - Test LifeCycle
    var sut: MenuViewController!
    var interactorSpy: MenuInteractorSpy!
    
    override func setUpWithError() throws {
        super.setUp()
        interactorSpy = MenuInteractorSpy()
        sut = MenuViewController()
        
        sut.interactor = interactorSpy
    }
    
    func testShouldPresentInitialDataWhenViewDidLoad() throws {
        // When
        sut.viewDidLoad()
        // Then
        XCTAssert(interactorSpy.presentInitialDataCalled, "Should present initial data when view is loaded")
    }
}
