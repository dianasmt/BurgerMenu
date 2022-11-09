//
// AppConstants.swift
// RMT-Mobile-New-iOS
//
// Created by Диана Смахтина on 10.08.22.
// 
//

import UIKit

enum Constants {
    static var screenFactor: CGFloat {
        get {
            switch UIDevice.current.type {
            case .iPadPro12_9, .iPadPro2_12_9, .iPadPro3_12_9, .iPadPro4_12_9:
                return 2.0
            case .iPad8:
                return 1.58
            default:
                return UIScreen.main.bounds.size.width / 414
            }
        }
    }
}
// io
