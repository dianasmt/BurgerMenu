//
//  ImageTitleTableViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 27.07.22.
//

import UIKit
import SnapKit

class ImageTitleTableViewCell: UITableViewCell {
    
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
    
    private lazy var text: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 12)
        label.textColor = .customGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpSubviews()
        setUpConstraints()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        addSubview(cellImageView)
        addSubview(titleLabel)
        addSubview(text)
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
        
        text.snp.makeConstraints { maker in
            maker.leading.equalTo(titleLabel)
            maker.topMargin.equalTo(titleLabel).offset(25)
        }
    }
    
    private func setupBindings() {
        themeProvider.register(observer: self)
    }

    override func fill(with item: Any?) {
        guard let item = item as? CellModel else {
            return
        }
        titleLabel.text = String.localString(stringKey: item.title)
        cellImageView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        text.text = String.localString(stringKey: item.subTitle)
    }
}

extension ImageTitleTableViewCell: Themeable {
    func setupTheme(theme: Theme) {
        backgroundColor = theme.colors.customBackgrounColor
        cellImageView.tintColor = theme.colors.burgerMenuIconColor
        titleLabel.textColor = theme.colors.customLabel
    }
}
