//
//  ChangeLangTableViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 28.07.22.
//

import UIKit

class ChangeLangTableViewCell: UITableViewCell {

    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 16)
        return label
    }()
    
    private lazy var langugeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(cellImageView)
        addSubview(titleLabel)
        addSubview(langugeLabel)
        setUpConstraints()
        setupBindings()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        cellImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(25)
            maker.leading.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(cellImageView).offset(35)
        }
        
        langugeLabel.snp.makeConstraints { maker in
            maker.trailingMargin.equalToSuperview().offset(-30)
            maker.centerY.equalTo(contentView)
        }
    }
    
    private func setupBindings() {
        themeProvider.register(observer: self)
    }

    override func fill(with item: Any?) {
        guard let item = item as? ChangeLangCellModel else {
            return
        }
        titleLabel.text = String.localString(stringKey: item.title)
        cellImageView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        langugeLabel.text = String.localString(stringKey: item.language)
    }
}

extension ChangeLangTableViewCell: Themeable {
    func setupTheme(theme: Theme) {
        backgroundColor = theme.colors.customBackgrounColor
        cellImageView.tintColor = theme.colors.burgerMenuIconColor
        titleLabel.textColor = theme.colors.burgerMenuSpecialLabelColor
        langugeLabel.textColor = theme.colors.customLabel
    }
}
