//
//  Menu.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 22.08.22.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class MenuInteractorSpy: MenuInteractorInput {
    func clickOnNumber(number: String) {
        
    }
    
    var presentInitialDataCalled = false
    
    func presentInitialData() {
        presentInitialDataCalled = true
    }
    
    var clickOnNumberCalled = false
    
    func clickOnNumber(number: String) {
        clickOnNumberCalled = true
    }
}
