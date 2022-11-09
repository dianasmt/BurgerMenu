//
//  ATMDetailsPopUpView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Islam Shamkhanov on 15.09.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ATMDetailsPopUpViewDelegate: AnyObject {
    func handleCloseButton(department: DepartmentsResponse)
    func handleSeeDetailsButton(department: DepartmentsResponse)
}

class ATMDetailsPopUpView: UIView, Themeable {
    private let bag = DisposeBag()
    weak var delegate: ATMDetailsPopUpViewDelegate?
    
    private enum Consts {
        static let details = "atm_popup_details"
        static let personImage = "ATMS_walking_person"
        static let closeIcon = "ATMs_popup_close"
        static let open = "atm_status_open"
        static let closed = "atm_status_closed"
    }
    
    private lazy var atmNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .fontSFProText(type: .bold, size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        label.textColor = .customBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var workScheduleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        label.textColor = .customBlack
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 12)
        return label
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.addSubview(statusLabel)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var servicesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 30, height: 30)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ATMServicesCollectionViewCell.self, forCellWithReuseIdentifier: ATMServicesCollectionViewCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Consts.personImage)?.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        label.textColor = .customBlack
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var seeDetailsButton: UIButton = {
        let button = UIButton()
        button.setTitle(String.localString(stringKey: Consts.details), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .fontSFProText(type: .bold, size: 14)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Consts.closeIcon)?.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 14
        
        addSubview(atmNameLabel)
        addSubview(addressLabel)
        addSubview(workScheduleLabel)
        addSubview(backView)
        addSubview(servicesCollectionView)
        addSubview(personImageView)
        addSubview(distanceLabel)
        addSubview(seeDetailsButton)
        addSubview(closeButton)
    }
    
    func setupTheme(theme: Theme) {
        backgroundColor = theme.colors.customBackgrounColor
        atmNameLabel.textColor = theme.colors.customLabel
        closeButton.tintColor = theme.colors.customLabel
        seeDetailsButton.setTitleColor(theme.colors.customLabel, for: .normal)
        let labelColor: UIColor = theme == .dark ? .whiteGray : .customBlack
        addressLabel.textColor = labelColor
        workScheduleLabel.textColor = labelColor
        distanceLabel.textColor = labelColor
        backView.backgroundColor = theme == .dark ? .customLighterGray : .customLightYellow
        personImageView.tintColor = theme.colors.customLabel
    }
    
    private func setupConstraints() {
        atmNameLabel.snp.makeConstraints { make in
            make.top.equalTo(13.5)
            make.leading.equalTo(21)
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(25)
            make.top.equalTo(12)
            make.trailing.equalToSuperview().offset(-21.5)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(atmNameLabel.snp.bottom).offset(6.5)
            make.leading.equalTo(21)
        }
        
        workScheduleLabel.snp.makeConstraints { make in
            make.leading.equalTo(21)
            make.top.equalTo(addressLabel.snp.bottom).offset(19.5)
        }
        
        backView.snp.makeConstraints { make in
            make.centerY.equalTo(workScheduleLabel)
            make.leading.equalTo(workScheduleLabel.snp.trailing).offset(15)
            make.width.equalTo(statusLabel).offset(20)
            make.height.equalTo(25)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        servicesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.leading.equalTo(21)
            make.height.equalTo(30)
            make.trailing.equalToSuperview().offset(-21)
        }
        
        personImageView.snp.makeConstraints { make in
            make.top.equalTo(servicesCollectionView.snp.bottom).offset(15)
            make.leading.equalTo(21)
            make.width.height.equalTo(20)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(personImageView.snp.trailing).offset(5)
            make.centerY.equalTo(personImageView)
        }
        
        let separator: UIView = {
            let view = UIView()
            view.backgroundColor = .customSeparator
            return view
        }()
        addSubview(separator)
        separator.snp.makeConstraints { make in
            make.top.equalTo(personImageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        seeDetailsButton.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    private func getIconImageView(with image: String) {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGreyColor
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(named: image)
        imageView.contentMode = .center
    }
    
    func fill(with model: ATMDetailsPopUpViewModel, data: DepartmentsResponse) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ATMServicesSectionDataSource>(
            configureCell: { datasource, tableView, indexPath, item in
                let cell = self.servicesCollectionView.dequeueReusableCell(withReuseIdentifier: ATMServicesCollectionViewCell.className, for: indexPath)
                cell.fill(with: item)
                cell.backgroundColor = self.themeProvider.theme == .dark ? .customLighterGray : .lightGreyColor
                return cell
            })
        
        Observable.just(model.servicesDataSource)
            .bind(to: servicesCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        servicesCollectionView
            .rx
            .itemSelected
            .subscribe(onNext:{ indexPath in
                self.servicesCollectionView.isUserInteractionEnabled = false
                let tooltip = ATMServiceTooltip()
                tooltip.fill(title: model.services[indexPath.row])
                guard let cell = self.servicesCollectionView.cellForItem(at: indexPath) else {
                    return
                }

                let offset = tooltip.frame.size.height - 30
                self.addSubview(tooltip)
                tooltip.snp.makeConstraints { make in
                    make.bottom.equalTo(self.servicesCollectionView.snp.top).offset(-30 - offset)
                    make.centerX.equalTo(cell)
                }
                cell.backgroundColor = .systemYellow
                tooltip.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        cell.backgroundColor = self.themeProvider.theme == .dark ? .customLighterGray : .lightGreyColor
                        tooltip.isHidden = true
                    self.servicesCollectionView.isUserInteractionEnabled = true
                    tooltip.removeFromSuperview()
                }
                
            }).disposed(by: bag)
        
        atmNameLabel.text = model.name
        addressLabel.text = model.address
        workScheduleLabel.text = model.workSchedule
        switch model.status {
        case .open:
            statusLabel.textColor = .systemGreen
            statusLabel.text = String.localString(stringKey: Consts.open)
        case .closed:
            statusLabel.textColor = themeProvider.theme == .dark ? .customLightPink : .customRed
            statusLabel.text = String.localString(stringKey: Consts.closed)
        }
        
        if let distance = model.distance {
            distanceLabel.text = distance
            personImageView.isHidden = false
        } else {
            distanceLabel.text = ""
            personImageView.isHidden = true
        }
        
        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.delegate?.handleCloseButton(department: data)
            })
            .disposed(by: self.bag)
        
        seeDetailsButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.delegate?.handleSeeDetailsButton(department: data)
            })
            .disposed(by: self.bag)
    }
}
