//
// UIView+Extensions.swift
// RMT-Mobile-New-iOS
//
// Created by Диана Смахтина on 26.08.22.
// 
//

import UIKit

extension UIView {
    func roundCorners(
        corners: UIRectCorner = [.allCorners],
        cornerRadius: CGFloat = 12 * Constants.screenFactor
    ) {
        let bezierPath = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
