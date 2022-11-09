//
//  WeekdaysCollectionView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import UIKit
import SnapKit

class WeekdaysCollectionViewCell: UICollectionViewCell, Themeable {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .medium, size: 12)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        setupUI()
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been yet implemented")
    }
    
    func setupTheme(theme: Theme) {
        titleLabel.textColor = theme.colors.customLabel
    }
    
    private func setupUI() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        layer.cornerRadius = 15
        backgroundColor = .lightGreyColor
    }
    
    func fill(with weekday: String) {
        titleLabel.text = weekday
    }
    
    override func fill(with item: Any?) {
        guard let item = item as? WeekdayCellProtocol else {
            return
        }
        titleLabel.attributedText = nil
        if item.isUnderlined {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let underlineAttributedString = NSAttributedString(string: item.title, attributes: underlineAttribute)
            titleLabel.attributedText = underlineAttributedString
        } else {
            titleLabel.text = item.title
        }
        if item.isSelected {
            backgroundColor = themeProvider.theme == .light ? .customLightYellow : .customDarkYellow
        } else {
            backgroundColor = themeProvider.theme == .dark ? .customLighterGray : .lightGreyColor
        }
    }
}
