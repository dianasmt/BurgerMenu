//
//  CurrencyCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 11.08.2022.
//

import UIKit
import SnapKit

class CurrencyCell: UITableViewCell, Themeable {
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .bold, size: 14)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 12)
        return label
    }()
    
    private lazy var valueBuyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 14)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var valueSellLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 14)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubviews()
        setUpConstraints()
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        self.addSubview(cellImageView)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(valueBuyLabel)
        self.addSubview(valueSellLabel)
    }
    
    private func setUpConstraints() {
        cellImageView.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(18)
            maker.height.equalTo(30)
            maker.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(cellImageView)
            maker.leading.equalTo(cellImageView.snp.trailing).offset(13)
        }
        
        descriptionLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(titleLabel)
            maker.topMargin.equalTo(titleLabel).offset(20)
        }
        valueBuyLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(105)
            maker.height.width.equalTo(50)
            maker.centerY.equalToSuperview()
        }
        valueSellLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(15)
            maker.height.width.equalTo(50)
            maker.centerY.equalToSuperview()
        }
    }
    
    func setupTheme(theme: Theme) {
        backgroundColor = .clear
        titleLabel.textColor = theme.colors.customLabel
        descriptionLabel.textColor = theme == .dark ? .darkGray : .darkGreyColor
        valueBuyLabel.textColor = theme.colors.customLabel
        valueSellLabel.textColor = theme.colors.customLabel
    }
    
    override func fill(with item: Any?) {
        guard let item = item as? CurrencyModel else {
            return
        }
        cellImageView.image = UIImage(named: item.flagImage)
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        valueBuyLabel.text = "\(item.valueBuy)"
        valueSellLabel.text = "\(item.valueSell)"
    }
}
