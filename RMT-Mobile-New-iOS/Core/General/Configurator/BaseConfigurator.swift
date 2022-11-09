//
// BaseConfigurator.swift
// RMT-Mobile-New-iOS
//
// Created by Диана Смахтина on 10.08.22.
// 
//

import UIKit

protocol BaseConfigurator {
    associatedtype ViewController: UIViewController
    
    @discardableResult static func build(with viewController: ViewController) -> ViewController
}

protocol BaseDelegateConfigurator {
    associatedtype ViewController: UIViewController
    associatedtype Delegate
    
    @discardableResult static func build(with viewController: ViewController, delegate: Delegate?) -> ViewController
}
