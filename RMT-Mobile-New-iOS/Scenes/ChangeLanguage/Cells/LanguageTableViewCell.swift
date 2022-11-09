//
//  LanguageTableViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 4.08.22.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 16)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        self.addSubview(iconImageView)
        setUpConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalTo(contentView)
            maker.leftMargin.equalTo(contentView).offset(25)
        }
        iconImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(25)
            maker.trailing.equalToSuperview().offset(-15)
            maker.centerY.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        themeProvider.register(observer: self)
    }
    
    override func fill(with item: Any?) {
        guard let item = item as? LanguageModel else {
            return
        }
        titleLabel.text = String.localString(stringKey: item.title)
        iconImageView.image = UIImage(named: item.icon)
        iconImageView.isHidden = !(Languages.current == item.language)
    }
}

extension LanguageTableViewCell: Themeable {
    func setupTheme(theme: Theme) {
        backgroundColor = theme.colors.customBackgrounColor
        titleLabel.textColor = theme.colors.customLabel
    }
}
