//  AppDelegate.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 01.07.2022.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum AppConst {
        static let APIKey = "AIzaSyAWoco3oVnIUE2wzcHZB5NxYdnutXblZOs"
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(AppConst.APIKey)
        let vc = WelcomeScreenNavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        setupInitialTheme()
        return true
    }
    
    private func setupInitialTheme() {
        if #available(iOS 13.0, *) {
            if UserDefaults.isDark {
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
