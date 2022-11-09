//
//  DepartmentTableHeaderView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

protocol DepartmentHeaderViewDelegate: AnyObject {
    func didTapShowWorkingScheduleButton()
}

final class DepartmentTableHeaderView: UITableViewHeaderFooterView, Themeable {
    weak var delegate: DepartmentHeaderViewDelegate?
    private let bag = DisposeBag()
    private enum Consts {
        static let open = "atm_status_open"
        static let closed = "atm_status_closed"
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .customDarkYellow
        imageView.image = UIImage(named: "department_header_icon")
        imageView.layer.shadowRadius = 2
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowColor = UIColor.black.cgColor
        return imageView
    }()
    
    private lazy var departmentNameLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProText(type: .bold, size: 14)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private lazy var departmentAddressLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        label.textColor = .customBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var departmentDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        label.textColor = .customBlack
        return label
    }()
    
    private lazy var departmentOpenStatusLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        return label
    }()
    
    private lazy var departmentWorkingHoursLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        label.text = "9:00 - 18:00"
        label.textColor = .customBlack
        return label
    }()
    
    private lazy var showHideButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(iconImageView)
        addSubview(departmentNameLabel)
        addSubview(departmentAddressLabel)
        addSubview(departmentDistanceLabel)
        addSubview(departmentOpenStatusLabel)
        addSubview(departmentWorkingHoursLabel)
        addSubview(showHideButton)
        setupUI()
        setupBindings()
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }
    
    func setupTheme(theme: Theme) {
        backgroundColor = .clear
        departmentNameLabel.textColor = theme.colors.customLabel
        departmentDistanceLabel.textColor = theme.colors.customLabel
        departmentWorkingHoursLabel.textColor = theme.colors.customLabel
        departmentAddressLabel.textColor = theme == .dark ? .whiteGray : .customBlack
        showHideButton.imageView?.tintColor = theme.colors.customLabel
    }
    
    private func setupUI() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(19.5)
            make.width.height.equalTo(40)
            make.leading.equalTo(35)
        }
        
        departmentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
        }
        
        departmentAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(departmentNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(iconImageView.snp.trailing).offset(15)
        }
        
        let bottomStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        let innerStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.spacing = 7
            stackView.distribution = .equalSpacing
            return stackView
        }()
        
        innerStackView.addArrangedSubview(departmentWorkingHoursLabel)
        innerStackView.addArrangedSubview(showHideButton)
        
        bottomStackView.addArrangedSubview(departmentDistanceLabel)
        bottomStackView.addArrangedSubview(departmentOpenStatusLabel)
        bottomStackView.addArrangedSubview(innerStackView)
        
        addSubview(bottomStackView)
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(departmentAddressLabel.snp.bottom).offset(10)
            make.leading.equalTo(35)
            make.trailing.equalToSuperview().offset(-14)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        let separatorView: UIView = {
            let view = UIView()
            view.backgroundColor = .customSeparator
            return view
        }()
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func setupBindings() {
        showHideButton.rx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.delegate?.didTapShowWorkingScheduleButton()
            })
            .disposed(by: bag)
    }
    
    func fill(with item: Any) {
        guard let item = item as? DepartmentInfoHeaderModel else {
            return
        }
        departmentNameLabel.text = item.name
        departmentAddressLabel.text = item.address
        if let distance = item.distance {
            departmentDistanceLabel.text = distance
        } else {
            departmentDistanceLabel.text = ""
        }
        
        departmentWorkingHoursLabel.text = item.workingHours
        
        switch item.status {
        case .open:
            departmentOpenStatusLabel.textColor = .customGreen
            departmentOpenStatusLabel.text = String.localString(stringKey: Consts.open)
        case .closed:
            departmentOpenStatusLabel.textColor = themeProvider.theme == .dark ? .customLightPink : .customRed
            departmentOpenStatusLabel.text = String.localString(stringKey: Consts.closed)
        }
        
        showHideButton.setImage(UIImage(named: item.showWorkSchedule ? "department_show_arrow" : "department_hide_arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
}
