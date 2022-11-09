//
//  ErrorReportRouterTests.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 26/09/2022.
//

import XCTest
@testable import RMT_Mobile_New_iOS

class ErrorReportRouterTest: XCTestCase {
    var sut: ErrorReportRouter!
    var delegateSpy: DelegateSpy!

    override func setUpWithError() throws {
        super.setUp()
        sut = ErrorReportRouter()
        delegateSpy = DelegateSpy()
        
        sut.delegate = delegateSpy
    }
    
    func testNavigation() throws {
        //When
        sut.navigateToMailComposerViewController(recepients: [String.empty], subject: String.empty, message: String.empty, isHTML: true)
        //Then
        XCTAssert(delegateSpy.loadMailComposerInvoked, "loadMailComposer should ask the delegate to load Mail Composer")
    }
    
    func testParameters() throws {
        let recepients = ["Test recepients"]
        let subject = "Test subject"
        let message =  "Test message"
        let isHTML = true
        //When
        sut.navigateToMailComposerViewController(recepients: recepients, subject: subject, message: message, isHTML: isHTML)
        //Then
        XCTAssertNotNil(delegateSpy.mailParameters)
        XCTAssert(recepients == delegateSpy.mailParameters?.recepients, "recepients should be shown")
        XCTAssert(subject == delegateSpy.mailParameters?.subject, "subject should be shown")
        XCTAssert(message == delegateSpy.mailParameters?.message, "message should be shown")
        XCTAssert(isHTML == delegateSpy.mailParameters?.isHTML, "isHTML should be shown")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        delegateSpy = nil
        try super.tearDownWithError()
    }
}
