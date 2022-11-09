//
//  ATMsViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 29.08.22.
//

import UIKit
import GoogleMaps
import SnapKit
import RxSwift
import RxCocoa

import CoreLocation
import Moya

class ATMsViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private lazy var locationService = LocationService()
    
    var interactor: ATMsInteractorInput!
    private var mapView: GMSMapView!
    private var zoom: Float = 10.0
    private lazy var popUp = ATMDetailsPopUpView()
    
    private var arrayOfBanks = [DepartmentsResponce]()
    
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "ATMs_title_menu"
        static let markerImageName = "ATMs_my_location_pin"
        static let atmImageName = "ATMs_atm"
        static let departmentImageName = "ATMs_department"
        static let terminalImageName = "ATMs_terminal"
    }
    
    // MARK: - Outlets
    private lazy var pullUpContainer: PullUpContainerATMs = {
        let pullUp = PullUpContainerATMs(frame: self.view.frame)
        return pullUp
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var zoomInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ATMs_location_plus"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var zoomOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ATMs_location_minus"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var myLocationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ATMs_find_my_location"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ATMs_bank_search"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    // MARK: - Override properties
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMap()
        self.addSubviews()
        self.setUpConstraints()
        self.setUpPullUp()
        self.setUpBlur()
        self.locationService.locationManager.delegate = self
        self.interactor.presentInitialData()
        if #available(iOS 14.0, *) {
            checkStatus(didChangeAuthorization: locationService.locationManager.authorizationStatus)
        } else {
            checkStatus(didChangeAuthorization: CLLocationManager.authorizationStatus())
        }
        self.setupBindings()
        self.interactor.loadDepartments()
    }
    
    private func networkPins(departments: [DepartmentsResponce]) {
        for department in departments {
            guard let bankCoordinates = department.coordinates else { return }
            let pinCoordinates = self.createCoordinates(stringCoordinates: bankCoordinates)
            let imageName = self.checkType(department: department)
            self.addingPin(coordinates: pinCoordinates, imageName: imageName)
        }
    }
    
    private func addingPin(coordinates: CLLocationCoordinate2D, imageName: String) {
        let marker = GMSMarker()
        marker.iconView = UIImageView(image: UIImage(named: imageName))
        marker.position = coordinates
        marker.map = mapView
    }
    
    private func createCoordinates(stringCoordinates: String) -> CLLocationCoordinate2D {
        let coordinates = stringCoordinates.components(separatedBy: ", ")
        guard let latitude = Double(coordinates[0]), let longitude = Double(coordinates[1])
        else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private func checkType(department: DepartmentsResponce) -> String {
        guard let type = department.type else { return Const.atmImageName }
        switch type {
        case DepartmentType.department.rawValue:
            return Const.departmentImageName
        case DepartmentType.atm.rawValue:
            return Const.atmImageName
        case DepartmentType.terminal.rawValue:
            return Const.terminalImageName
        default:
            return Const.atmImageName
        }
    }
    
    private func addSubviews() {
        [mapView, zoomInButton, zoomOutButton, searchButton, myLocationButton, pullUpContainer]
            .forEach { self.view.addSubview($0) }
    }
    
    private func setUpPullUp() {
        pullUpContainer.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    private func setUpBlur() {
        self.view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpConstraints() {
        zoomInButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(318 * Constants.screenFactor)
            make.height.width.equalTo(50)
            make.trailing.equalToSuperview().offset(-15 * Constants.screenFactor)
        }
        
        zoomOutButton.snp.makeConstraints { make in
            make.top.equalTo(zoomInButton).offset(55)
            make.height.width.equalTo(50)
            make.trailing.equalToSuperview().offset(-15 * Constants.screenFactor)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.top.equalTo(zoomOutButton).offset(85)
            make.height.width.equalTo(50)
            make.trailing.equalToSuperview().offset(-15 * Constants.screenFactor)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100 * Constants.screenFactor)
            make.height.width.equalTo(50)
            make.leading.equalToSuperview().offset(15 * Constants.screenFactor)
        }
    }
    
    private func setupBindings() {
        zoomInButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.zoom += 1
                self.mapView.animate(toZoom: weakSelf.zoom)
            })
            .disposed(by: self.disposeBag)
        
        zoomOutButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.zoom -= 1
                self.mapView.animate(toZoom: weakSelf.zoom)
            })
            .disposed(by: self.disposeBag)
        
        myLocationButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                guard let coordinates = weakSelf.locationService.getLocation() else { return }
                let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: weakSelf.zoom)
                weakSelf.mapView.camera = camera
                weakSelf.mapView.animate(to: camera)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createMap() {
        mapView = GMSMapView.init(frame: self.view.frame)
        mapView.delegate = self
    }
    
    private func createMarker(for coordinates: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        marker.iconView = UIImageView(image: UIImage(named: Const.markerImageName))
        marker.position = coordinates
        marker.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkStatus(didChangeAuthorization: status)
    }
    
    func checkStatus(didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            visualEffectView.alpha = 0
            guard let coordinates = locationService.getLocation() else { return}
            let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: zoom)
            mapView.camera = camera
            createMarker(for: coordinates)
            mapView.animate(to: camera)
            myLocationButton.setImage(UIImage(named: "ATMs_find_my_location"), for: .normal)
            //            mapView.settings.myLocationButton = true
        case .notDetermined:
            locationService.getLocation()
        case .restricted, .denied:
            visualEffectView.alpha = 0
            myLocationButton.setImage(UIImage(named: "ATMs_my_location_off"), for: .normal)
        default:
            break
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        interactor.handlePinTap(pin: marker)
        return true
    }
    
    private func animateScaleIn(desiredView: UIView) {
        desiredView.isHidden = false
        
        desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        desiredView.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
            desiredView.transform = CGAffineTransform.identity
        }
    }
    
    private func animateScaleOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 0
        }, completion: { (success: Bool) in
            desiredView.isHidden = true
        })
    }
    
    private func setPopUpView(with model: ATMDetailsPopUpViewModel) {
        popUp = {
            let popup = ATMDetailsPopUpView()
            popup.isHidden = true
            popup.delegate = self
            return popup
        }()
        
        self.view.addSubview(popUp)
        popUp.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(27)
            make.trailing.equalToSuperview().offset(-23)
        }
        popUp.fill(with: model)
    }
}

extension ATMsViewController: ATMsPresentorOutput {
    func displayPins(departments: [DepartmentsResponce]) {
        self.networkPins(departments: departments)
    }
    
    func displayData(sections: [ATMsSectionDataSource]) {
        self.pullUpContainer.transferData(sections: sections)
    }
    
    func displayPopUp(with model: ATMDetailsPopUpViewModel) {
        setPopUpView(with: model)
        animateScaleIn(desiredView: visualEffectView)
        animateScaleIn(desiredView: popUp)
    }
}

extension ATMsViewController: ATMDetailsPopUpViewDelegate {
    func handleCloseButton() {
        animateScaleOut(desiredView: popUp)
        animateScaleOut(desiredView: visualEffectView)
    }
    
    func handleSeeDetailsButton() {
        
    }
}
