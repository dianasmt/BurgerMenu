//
//  MenuViewControllerSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 22.08.22.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class MenuViewControllerSpy: MenuPresentorOutput {
    func displayPhoneDialer(number: String) {
        
    }
    
    var displayDataCalled = false
    private(set) var displayedSections: [SectionDataSource] = []
    
    func displayData(sections: [SectionDataSource]) {
        displayDataCalled = true
        displayedSections = sections
    }
    
    var displayPhoneDialerCalled = false
    private(set) var displayedNumber: String = String.empty
    
    func displayPhoneDialer(number: String) {
        displayPhoneDialerCalled = true
        displayedNumber = number
    }
}
