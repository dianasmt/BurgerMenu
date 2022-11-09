//
//  DepartmentTableSectionHeaderView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import UIKit
import SnapKit

final class DepartmentTableSectionHeaderView: UITableViewHeaderFooterView, Themeable {
    enum DepartmentHeaderOffset {
        case top
        case regular
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProText(type: .semibold, size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    convenience init(offset: DepartmentHeaderOffset) {
        self.init(reuseIdentifier: DepartmentTableSectionHeaderView.className)
        addSubview(titleLabel)
        setUpUI(offset: offset)
        themeProvider.register(observer: self)
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }
    
    func setupTheme(theme: Theme) {
        titleLabel.textColor = theme.colors.customLabel
    }
    
    private func setUpUI(offset: DepartmentHeaderOffset) {
        let topView = UIView()
        addSubview(topView)
        
        topView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(offset == .top ? 30 : 25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.leading.equalTo(33)
        }
        
        let bottomView = UIView()
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(15)
        }
    }
    
    func fill(title: String) {
        titleLabel.text = title
    }
}
