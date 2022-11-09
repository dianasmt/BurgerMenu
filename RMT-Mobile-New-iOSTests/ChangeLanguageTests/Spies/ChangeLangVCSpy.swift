//
//  ChangeLangVCSpy.swift
//  RMT-Mobile-New-iOSTests
//
//  Created by Диана Смахтина on 23.08.22.
//

import Foundation
@testable import RMT_Mobile_New_iOS

class ChangeLangVCSpy: ChangeLangPresentorOutput {
    var displayDataCalled = false
    private(set) var displayedLanguages: [LanguageDataSource] = []
    
    func displayData(languages: [LanguageDataSource]) {
        displayDataCalled = true
        displayedLanguages = languages
    }
}
