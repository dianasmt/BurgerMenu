//
//  CurrencyHeaderView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 15.08.2022.
//

import UIKit
import SnapKit

class CurrencyHeaderView: UIView, Themeable {
    
    private lazy var currencyTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .medium, size: 14)
        label.textColor = .customBlack
        return label
    }()
    
    private lazy var buyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .medium, size: 14)
        label.textColor = .customBlack
        label.textAlignment = .right
        return label
    }()
    
    private lazy var sellLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .medium, size: 14)
        label.textColor = .customBlack
        label.textAlignment = .right
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .customGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
        setUpConstraints()
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTheme(theme: Theme) {
        currencyTitleLabel.textColor = theme.colors.customLabel
        sellLabel.textColor = theme.colors.customLabel
        buyLabel.textColor = theme.colors.customLabel
    }
    
    private func setUpSubviews() {
        [currencyTitleLabel, buyLabel, sellLabel, separatorView].forEach { addSubview($0) }
    }
    
    private func setUpConstraints() {
        currencyTitleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().offset(-12)
        }
        
        buyLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(105)
            maker.bottom.equalToSuperview().offset(-12)
        }
        
        sellLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(15)
            maker.bottom.equalToSuperview().offset(-12)
        }
        
        separatorView.snp.makeConstraints { maker in
            maker.left.bottom.right.equalToSuperview()
            maker.height.equalTo(0.5)
        }
    }
    
    func updateUI(model: CurrencyHeaderModel) {
        currencyTitleLabel.text = model.currencyTitle
        buyLabel.text = model.buyTitle
        sellLabel.text = model.sellTitle
    }
}
