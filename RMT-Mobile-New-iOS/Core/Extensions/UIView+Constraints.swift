//
// UIView+Constraints.swift
// RMT-Mobile-New-iOS
//
// Created by Диана Смахтина on 10.08.22.
// 
//

import SnapKit
import UIKit

extension UIView {
    func stretchLayout() {
        self.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
