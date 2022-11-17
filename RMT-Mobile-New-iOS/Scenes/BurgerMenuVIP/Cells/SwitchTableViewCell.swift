//
//  SwitchTableViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 25.07.22.
//

import UIKit
import SnapKit
import RxSwift

protocol SwitchTableViewCellDelegate: AnyObject {
    func darkModeSwitchTapped(enabled: Bool)
}

final class SwitchTableViewCell: UITableViewCell {
    weak var delegate: SwitchTableViewCellDelegate?
    private let bag = DisposeBag()
    
    private lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        return switcher
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpSubviews()
        setUpConstraints()
        setupBindings()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("fatal")
    }
    
    private func setUpSubviews() {
        addSubview(iconImageView)
        addSubview(label)
        contentView.addSubview(switcher)
    }
    
    private func setUpConstraints() {
        iconImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(25)
            maker.leading.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
        }
        label.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leftMargin.equalTo(iconImageView).offset(35)
        }
        switcher.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailingMargin.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        themeProvider.register(observer: self)
        switcher.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
    }
    
    @objc private func didTapSwitch() {
        themeProvider.toggleTheme()
    }
    
    override func fill(with item: Any?) {
        guard let item = item as? SwitchCellModel else {
            return
        }
        label.text = String.localString(stringKey: item.title)
        iconImageView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        switcher.isOn = themeProvider.theme == .dark
    }
}

extension SwitchTableViewCell: Themeable {
    func setupTheme(theme: Theme) {
        backgroundColor = theme.colors.customBackgrounColor
        iconImageView.tintColor = theme.colors.burgerMenuIconColor
        label.textColor = theme.colors.burgerMenuSpecialLabelColor
    }
}
