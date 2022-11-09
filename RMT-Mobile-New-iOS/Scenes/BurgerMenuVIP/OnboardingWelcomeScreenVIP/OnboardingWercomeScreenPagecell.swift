//
//  OnboardingWelcomeScreenPagecell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Aibek on 03.08.2022.
//

import UIKit

class PageCell: UICollectionViewCell {

private lazy var imageView = UIImageView()

private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = .fontSFProText(type: .bold, size: 24)
    return label
}()

private lazy var extraLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = .fontSFProText(type: .regular, size: 14)
    return label
}()

override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

private func setupLayout() {
    addSubview(imageView)
    imageView.snp.makeConstraints { maker in
        maker.top.equalToSuperview()
        maker.height.width.equalTo(284)
        maker.centerX.equalToSuperview()
    }
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints{maker in
        maker.top.equalTo(imageView.snp.bottom).inset(-64)
        maker.width.equalTo(326)
        maker.centerX.equalToSuperview()
    }
    
    addSubview(extraLabel)
    extraLabel.snp.makeConstraints{maker in
        maker.top.equalTo(imageView.snp.bottom).inset(-116)
        maker.width.equalTo(326)
        maker.centerX.equalToSuperview()
    }
}

func updateUI(page: PageModel) {
    imageView.image = UIImage(named: page.imageName)
    titleLabel.text = page.label
    extraLabel.text = page.extralabel
}
}

