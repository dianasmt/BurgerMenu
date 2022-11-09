//
//  DelegateSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class DelegateSpy: WelcomeScreenDelegate {
    
    struct MailParameters {
        let recepients: [String]
        let subject: String
        let message: String
        let isHTML: Bool
    }
    
    var loadChangeLangCalled = false
    var loadMailComposerInvoked = false
    var mailParameters: MailParameters?
    
    func loadBurgerMenu() {}
    func loadRegistration() {}
    func loadCurrencyExchange() {}
    func loadChangeLang() {
        loadChangeLangCalled = true
    }
    func loadErrorReport() {}
    func loadMailComposer(recepients: [String], subject: String, message: String, isHTML: Bool) {
        loadMailComposerInvoked = true
        self.mailParameters = MailParameters.init(recepients: recepients, subject: subject, message: message, isHTML: isHTML)
    }
}
