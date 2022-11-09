//
//  PullUpCollectionViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 30.08.22.
//

import UIKit

class PullUpCollectionViewCell: UICollectionViewCell, Themeable {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 12)
        return label
    }()
    
    private lazy var viewCell: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6.0
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.viewCell.backgroundColor = themeProvider.theme == .dark ? .customDarkerYellow : .customYellow.withAlphaComponent(0.3)
                self.titleLabel.textColor = .black
                self.iconImageView.tintColor = .black
            } else {
                self.viewCell.backgroundColor = themeProvider.theme == .dark ? .grayishBlack : .lightGreyColor
                self.titleLabel.textColor = themeProvider.theme.colors.customLabel
                self.iconImageView.tintColor = themeProvider.theme == .dark ? .darkGray : .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setUpConstraints()
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTheme(theme: Theme) {
        titleLabel.textColor = theme.colors.customLabel
        viewCell.backgroundColor = theme.colors.containerCellBackgroundColor
        iconImageView.tintColor = theme == .dark ? .darkGray : .black
    }
    
    private func addSubviews() {
        addSubview(viewCell)
        viewCell.addSubview(iconImageView)
        viewCell.addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        viewCell.snp.makeConstraints { maker in
            maker.height.equalTo(25)
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { maker in
            maker.width.equalTo(25)
            maker.leading.equalToSuperview().offset(10)
            maker.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(iconImageView).offset(30)
            maker.trailing.equalToSuperview().offset(-15)
            maker.top.bottom.equalToSuperview()
        }
    }
    
    override func fill(with item: Any?) {
        guard let item = item as? ATMsCollectionModel else {
            return
        }
        titleLabel.text = String.localString(stringKey: item.title)
        iconImageView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
    }
}
