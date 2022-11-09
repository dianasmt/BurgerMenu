//
//  DepartmentWorkingHoursHeaderView.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 12.09.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol WorkingHoursHeaderViewDelegate: AnyObject {
    func didChooseWeekday(day: Int)
}

final class DepartmentWorkingHoursHeaderView: UITableViewHeaderFooterView, Themeable {
    private let bag = DisposeBag()
    weak var delegate: WorkingHoursHeaderViewDelegate?
    private var weekdaysDataSource = BehaviorRelay<[WeekdaysSectionDataSource]>(value: [])
    
    private enum Const {
           static let workSchedule = "department_work_schedule"
           static let iconImageName = "ATMs_open"
       }
       
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProText(type: .semibold, size: 14)
        label.text = .localString(stringKey: Const.workSchedule)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var weekdaysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 30, height: 30)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(WeekdaysCollectionViewCell.self, forCellWithReuseIdentifier: WeekdaysCollectionViewCell.className)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Const.iconImageName)?.withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    private lazy var departmentWorkingHoursLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProDisplay(type: .regular, size: 14)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupUI()
        setupBindings()
        themeProvider.register(observer: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }
    
    private func addSubviews() {
           addSubview(titleLabel)
           addSubview(weekdaysCollectionView)
           addSubview(iconImageView)
           addSubview(departmentWorkingHoursLabel)
       }
    
    func setupTheme(theme: Theme) {
        titleLabel.textColor = theme.colors.customLabel
        departmentWorkingHoursLabel.textColor = theme == .dark ? .whiteGray : .black
        iconImageView.tintColor = theme.colors.customLabel
    }
       
    private func setupUI() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.leading.equalTo(33)
        }
        
        weekdaysCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(270)
            make.leading.equalTo(33)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(weekdaysCollectionView.snp.bottom).offset(5)
            make.leading.equalTo(33)
            make.height.width.equalTo(25)
            make.bottom.equalToSuperview()
        }
        
        departmentWorkingHoursLabel.snp.makeConstraints { make in
            make.top.equalTo(weekdaysCollectionView.snp.bottom).offset(5)
            make.leading.equalTo(iconImageView.snp.trailing)
            make.centerY.equalTo(iconImageView)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<WeekdaysSectionDataSource>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdaysCollectionViewCell.className, for: indexPath) as? WeekdaysCollectionViewCell else { return WeekdaysCollectionViewCell() }
                cell.fill(with: item)
                return cell
            })
        
        weekdaysDataSource
            .bind(to: weekdaysCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        weekdaysCollectionView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe(onNext:  { weakSelf, value in
                weakSelf.delegate?.didChooseWeekday(day: value.row)
            })
            .disposed(by: bag)
    }
    
    func fill(with item: Any) {
        guard let item = item as? WorkScheduleHeaderModel else {
            return
        }
        weekdaysDataSource.accept([item.dataSource])
        departmentWorkingHoursLabel.text = item.workingHours
    }
}
