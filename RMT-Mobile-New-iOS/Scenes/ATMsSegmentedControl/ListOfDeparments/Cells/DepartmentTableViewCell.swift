//
//  DepartmentTableViewCell.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 14.09.22.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell, Themeable {
    
    enum Const {
        static let titleLabelName = "ATMs_title_menu"
        static let markerImageName = "ATMs_my_location_pin"
        static let atmImageName = "ATMs_atm"
        static let departmentImageName = "ATMs_department"
        static let terminalImageName = "ATMs_terminal"
        
        static let departmentName = "ATMs_name_department"
        static let atmName = "ATMs_name_atm"
        static let terminalName = "ATMs_name_terminal"

        static let atmOpen = "atm_status_open"
        static let atmClosed = "atm_status_closed"
        
        static let kilometr = "kilometers_short"
        static let metr = "meters_short"
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .bold, size: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 14)
        label.textColor = .customBlack
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 14)
        label.textColor = .customGreen
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 14)
        label.textColor = .customBlack
        return label
    }()
    
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .fontSFProText(type: .regular, size: 14)
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
        self.addSubview(iconImageView)
        self.addSubview(titleLabel)
        self.addSubview(addressLabel)
        self.addSubview(statusLabel)
        self.addSubview(scheduleLabel)
        self.addSubview(distanceLabel)
    }
    
    func setupTheme(theme: Theme) {
        backgroundColor = .clear
        titleLabel.textColor = theme.colors.customLabel
        distanceLabel.textColor = theme.colors.customLabel
        scheduleLabel.textColor = theme.colors.customLabel
        addressLabel.textColor = theme == .dark ? .whiteGray : .customBlack
    }
    
    private func setUpConstraints() {
        iconImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(40)
            maker.leading.equalToSuperview().offset(35)
            maker.top.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(iconImageView)
            maker.leading.equalTo(iconImageView).offset(55)
        }
        
        addressLabel.snp.makeConstraints { maker in
            maker.bottom.equalTo(iconImageView)
            maker.leading.equalTo(iconImageView).offset(55)
            maker.trailing.equalToSuperview().offset(-15)
        }
        
        statusLabel.snp.makeConstraints { maker in
            maker.top.equalTo(addressLabel).offset(30)
            maker.leading.equalToSuperview().offset(120)
        }
        
        distanceLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(iconImageView)
            maker.centerY.equalTo(statusLabel)
        }
        
        scheduleLabel.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().offset(-15)
            maker.centerY.equalTo(statusLabel)
        }
    }

    override func fill(with item: Any?) {
        guard let item = item as? DepartmentsResponse else {
            return
        }
        checkType(department: item)
        checkForSchedule(department: item)
        checkForStatus(status: item.status)
        addressLabel.text = item.address
        getDistance(departmentCoordinates: item.coordinates)
    }
    
    private func checkType(department: DepartmentsResponse){
        switch department.type{
        case .atm:
            titleLabel.text = "\(String.localString(stringKey: Const.atmName)) №\(department.name)"
            iconImageView.image = UIImage(named: Const.atmImageName)
        case .terminal:
            titleLabel.text = "\(String.localString(stringKey: Const.terminalName)) №\(department.name)"
            iconImageView.image = UIImage(named: Const.terminalImageName)
        case .department:
            titleLabel.text = "\(String.localString(stringKey: Const.departmentName)) №\(department.name)"
            iconImageView.image = UIImage(named: Const.departmentImageName)
        }
    }
    
    private func checkForSchedule(department: DepartmentsResponse) {
        guard let currentSchedule = department.schedule.first(where: {
            $0.day.rawValue == String.currentWeekday.uppercased()
        }) else { return }
        scheduleLabel.text = "\(currentSchedule.from) - \(currentSchedule.to)"
    }
    
    private func checkForStatus(status: DepartmentStatus) {
        switch status {
        case .closed:
            statusLabel.text = String.localString(stringKey: Const.atmClosed)
            statusLabel.textColor = .customRed
        case .open:
            statusLabel.text = String.localString(stringKey: Const.atmOpen)
            statusLabel.textColor = .customGreen
        }
    }
    
    func getDistance(departmentCoordinates: String) {
        var distanceText: String?
        let stringCoordintes = departmentCoordinates.components(separatedBy: ", ").compactMap { Double($0) }
        guard let latitude = stringCoordintes.first, let longitude = stringCoordintes.last else { return }
            if let distance = LocationService(viewController: ATMsViewController()).getDistance(to: (latitude, longitude)) {
                if distance > 1000 {
                    distanceText = "\(distance/1000) " + String.localString(stringKey: Const.kilometr)
                } else {
                    distanceText = "\(distance) " + String.localString(stringKey: Const.metr)
                }
            }
        distanceLabel.text = distanceText
    }
}
