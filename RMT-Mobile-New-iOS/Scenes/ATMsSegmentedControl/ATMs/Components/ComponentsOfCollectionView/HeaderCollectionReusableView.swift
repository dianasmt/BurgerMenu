//
//  HeaderCollectionReusableView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 31.08.22.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView, Themeable {
    private let titleSectionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .semibold, size: 14)
        return label
    }()
    
    func configure(with title: String) {
        themeProvider.register(observer: self)
        titleSectionLabel.text = String.localString(stringKey: title)
        addSubview(titleSectionLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleSectionLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(22)
            maker.centerY.equalToSuperview()
        }
    }
    
    func setupTheme(theme: Theme) {
        titleSectionLabel.textColor = theme.colors.customLabel
    }
}
