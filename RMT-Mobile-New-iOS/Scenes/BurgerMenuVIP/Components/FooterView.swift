//
//  FooterView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 29.07.22.
//

import UIKit

final class BurgerFooterView: UITableViewHeaderFooterView {
    
    enum BurgerOffsetSide {
        case upper
        case lower
        case both
        case none
    }
    
    convenience init(offset: BurgerOffsetSide) {
        self.init(reuseIdentifier: BurgerFooterView.className)
        self.setUpUI(offset: offset)
        self.setupBindings()
    }
    
    private lazy var viewFooter = UIView()
    private lazy var separator = UIView()
    
    private func setUpUI(offset: BurgerOffsetSide) {
        let viewFooter = UIView()
        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = .customSeparator
            return view
        }()
        
        self.addSubview(viewFooter)
        viewFooter.addSubview(separator)
        
        viewFooter.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
            make.centerY.equalTo(viewFooter)
            
            var topOffset: CGFloat = 0
            var bottomOffset: CGFloat = 0
            
            switch offset {
            case .upper:
                topOffset = 20
                bottomOffset = 0
            case .lower:
                topOffset = 0
                bottomOffset = 20
            case .both:
                topOffset = 20
                bottomOffset = -20
            default:
                break
            }
            
            make.top.equalTo(topOffset)
            make.bottom.equalTo(bottomOffset)

        }
    }
    
    private func setupBindings() {
        themeProvider.register(observer: self)
    }
}

extension BurgerFooterView: Themeable {
    func setupTheme(theme: Theme) {
        contentView.backgroundColor = theme.colors.customBackgrounColor
        separator.backgroundColor = theme.colors.burgerMenuTableSeparatorColor
    }
}
