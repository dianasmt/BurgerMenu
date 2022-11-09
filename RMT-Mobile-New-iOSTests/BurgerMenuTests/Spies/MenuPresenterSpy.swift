//
//  MenuPresenterSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 22.08.22.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class MenuPresenterSpy: MenuInteractorOutput {
    func displayPhoneDialer(number: String) {
        
    }
    
    var displaySectionsCalled = false
    private(set) var sections: [SectionDataSource] = []
    
    func displaySections(sections: [SectionDataSource]) {
        displaySectionsCalled = true
        self.sections = sections
    }
    
    var displayPhoneDialerCalled = false
    private(set) var number: String = String.empty
    
    func displayPhoneDialer(number: String) {
        displayPhoneDialerCalled = true
        self.number = number
    }
}
