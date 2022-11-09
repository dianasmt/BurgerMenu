//
//  ATMServicesCollectionViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Islam Shamkhanov on 15.09.2022.
//

import Foundation
import UIKit
import SnapKit
import RxDataSources

class ATMServicesCollectionViewCell: UICollectionViewCell, Themeable {
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.tintColor = .black
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        themeProvider.register(observer: self)
        
        icon.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTheme(theme: Theme) {
        icon.tintColor = theme == .dark ? .customGray : .black
        backgroundColor = theme == .dark ? .customLighterGray : .lightGreyColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        icon.image = nil
    }
    
    override func fill(with item: Any?) {
        guard let item = item as? ATMServicesCollectionViewCellModel else {
            return
        }
        icon.image = UIImage(named: item.imageName)?.withRenderingMode(.alwaysTemplate)
    }
}
