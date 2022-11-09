//
//  UIKitExtensions.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 27.07.22.
//

import UIKit

extension NSObject {
    var stringFromClass: String { return NSStringFromClass(type(of: self)) }
    var className: String { return self.stringFromClass.components(separatedBy: ".").last! }
    
    static var stringFromClass: String { return NSStringFromClass(self) }
    static var className: String { return self.stringFromClass.components(separatedBy: ".").last! }
}

extension UITableViewCell {
    @objc func fill(with item: Any?) {}
}

extension UICollectionViewCell {
    @objc func fill(with item: Any?) {}
}
