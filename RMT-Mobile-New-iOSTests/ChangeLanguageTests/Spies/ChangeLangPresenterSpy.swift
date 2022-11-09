//
//  ChangeLangPresenterSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class ChangeLangPresenterSpy: ChangeLangInteractorOutput {
    var displayLanguagesCalled = false
    private(set) var languages: [LanguageDataSource] = []
    
    func displayLanguages(languages: [LanguageDataSource]) {
        displayLanguagesCalled = true
        self.languages = languages
    }
}
