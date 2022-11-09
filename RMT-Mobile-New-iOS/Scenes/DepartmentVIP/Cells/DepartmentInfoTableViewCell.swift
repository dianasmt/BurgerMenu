//
//  DepartmentTableViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import SnapKit

class DepartmentInfoTableViewCell: UITableViewCell, Themeable {
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProDisplay(type: .regular, size: 12)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpSubviews()
        setUpConstraints()
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpSubviews() {
        self.addSubview(cellImageView)
        self.addSubview(titleLabel)
    }
    
    func setupTheme(theme: Theme) {
        backgroundColor = .clear
        cellImageView.backgroundColor = theme == .dark ? .customLighterGray : .lightGreyColor
        cellImageView.tintColor = theme == .dark ? .customGray : .black
        titleLabel.textColor = theme == .dark ? .whiteGray : .black
    }
    
    private func setUpConstraints() {
        cellImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(30)
            maker.leading.equalToSuperview().offset(33)
            maker.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(cellImageView.snp.trailing).offset(10)
            maker.trailing.equalToSuperview().offset(-33)
        }
    }
    
    override func fill(with item: Any?) {
        guard let item = item as? ServiceCellModel else {
            return
        }
        titleLabel.text = item.title
        cellImageView.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
    }
}
