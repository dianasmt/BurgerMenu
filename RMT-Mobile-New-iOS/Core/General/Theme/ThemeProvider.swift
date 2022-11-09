//
//  ThemeProvider.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 05.09.2022.
//

import Foundation
import UIKit

protocol ThemeProvider {
    var theme: Theme { get }
    func register<Observer: Themeable>(observer: Observer)
    func toggleTheme()
}

class DarkThemeProvider: ThemeProvider {
    static let shared = DarkThemeProvider()
    var theme: Theme {
        didSet {
            UserDefaults.isDark = theme == .dark
            notifyObservers()
        }
    }
    private var observers: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    private init() {
        self.theme = UserDefaults.isDark ? .dark : .light
    }

    func toggleTheme() {
        theme = theme == .light ? .dark : .light
        setSystemSettings(theme: theme)
    }

    func register<Observer: Themeable>(observer: Observer) {
        observer.setupTheme(theme: theme)
        self.observers.add(observer)
    }

    private func notifyObservers() {
        DispatchQueue.main.async {
            self.observers.allObjects
                .compactMap({ $0 as? Themeable })
                .forEach({ $0.setupTheme(theme: self.theme) })
        }
    }
    
    private func setSystemSettings(theme: Theme) {
        if #available(iOS 13.0, *) {
            if theme == .dark {
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            } else {
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }
}
