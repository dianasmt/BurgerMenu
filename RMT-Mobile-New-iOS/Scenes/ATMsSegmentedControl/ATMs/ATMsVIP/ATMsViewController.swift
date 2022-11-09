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

protocol PullUpATMsServiceDelegate {
    func didSelectService(service: NameService)
}

class ATMsViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private lazy var locationService = LocationService(viewController: self)
    
    var interactor: ATMsInteractorInput!
    var router: ATMsViewRoutingLogic!
    private var mapView: GMSMapView!
    private lazy var popUp = ATMDetailsPopUpView()
    private var markers = [GMSMarker]()
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "ATMs_title_menu"
        static let markerImageName = "ATMs_my_location_pin"
        static let atmImageName = "ATMs_atm"
        static let departmentImageName = "ATMs_department"
        static let terminalImageName = "ATMs_terminal"
        static let zoomInImageName = "atms_location_plus"
        static let zoomOutImageName = "ATMs_location_minus"
        static let myLocationImageName = "ATMs_find_my_location"
        static let offLocationImagename = "ATMs_my_location_off"
    }
    
    // MARK: - Outlets
    private lazy var pullUpContainer: PullUpContainerATMs = {
        let pullUpController = PullUpContainerATMs.make()
        _ = pullUpController.view
        pullUpController.delegate = self
        return pullUpController
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var zoomInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Const.zoomInImageName), for: .normal)
        button.contentMode = .center
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.customShadowGray.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.customShadowGray.cgColor
        return button
    }()
    
    private lazy var zoomOutButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Const.zoomOutImageName), for: .normal)
        button.contentMode = .center
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.customShadowGray.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.customShadowGray.cgColor
        return button
    }()
    
    private lazy var myLocationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Const.myLocationImageName), for: .normal)
        button.contentMode = .center
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.customShadowGray.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowColor = UIColor.customShadowGray.cgColor
        return button
    }()
    
    private lazy var zoomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.zoomInButton, self.zoomOutButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var randomTapHandlerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addGestureRecognizer(randomTap)
        view.isHidden = true
        return view
    }()
    
    private lazy var doubleTapOnPopup: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer()
        doubleTap.isEnabled = false
        doubleTap.numberOfTapsRequired = 2
        return doubleTap
    }()
    
    private lazy var randomTap: UITapGestureRecognizer = {
        let mapTap = UITapGestureRecognizer()
        mapTap.isEnabled = false
        mapTap.numberOfTapsRequired = 1
        return mapTap
    }()
    
    // MARK: - Override properties
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor.presentInitialData()
        self.setUpViews()
        self.checkStatusGivenVersion()
        self.setupBindings()
    }
    
    private func displayPins(departments: [DepartmentsResponse]) {
        for department in departments {
            let bankCoordinates = department.coordinates
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
        markers.append(marker)
    }
    
    private func createCoordinates(stringCoordinates: String) -> CLLocationCoordinate2D {
        let coordinates = stringCoordinates.components(separatedBy: ", ").compactMap { Double($0) }
        guard let latitude = coordinates.first, let longitude = coordinates.last
        else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    private func checkType(department: DepartmentsResponse) -> String {
        switch department.type {
        case .department:
            return Const.departmentImageName
        case .atm:
            return Const.atmImageName
        case .terminal:
            return Const.terminalImageName
        }
    }
    
    private func addSubviews() {
        [mapView, zoomStackView, myLocationButton, randomTapHandlerView]
            .forEach { self.view.addSubview($0) }
    }
    
    private func setUpPullUp() {
        self.addPullUpController(self.pullUpContainer,
                                 initialStickyPointOffset: pullUpContainer.minPullupHeight ?? 100,
                                 animated: false)
        self.pullUpContainer.pullUpControllerMoveToVisiblePoint((pullUpContainer.minPullupHeight ?? 100) + 100, animated: true, completion: nil)
    }
    
    private func setUpBlur() {
        self.view.addSubview(visualEffectView)
        visualEffectView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpConstraints() {
        zoomStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.trailing.equalToSuperview().inset(15)
        }
        
        zoomInButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        zoomOutButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        myLocationButton.snp.makeConstraints { make in
            make.top.equalTo(zoomOutButton).offset(85)
            make.height.width.equalTo(40)
            make.trailing.equalToSuperview().offset(-15 * Constants.screenFactor)
        }
        
        randomTapHandlerView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupTheme(theme: Theme) {
        super.setupTheme(theme: theme)
        zoomInButton.backgroundColor = theme.colors.customBackgrounColor
        zoomOutButton.backgroundColor = theme.colors.customBackgrounColor
        myLocationButton.backgroundColor = theme.colors.customBackgrounColor
    }
    
    private func setUpViews() {
        self.createMap()
        self.addSubviews()
        self.setUpConstraints()
        self.setUpPullUp()
        self.setUpBlur()
    }
    
    private func setupBindings() {
        zoomInButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.mapView.animate(toZoom: weakSelf.mapView.camera.zoom + 1)
            })
            .disposed(by: self.disposeBag)
        
        zoomOutButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.mapView.animate(toZoom: weakSelf.mapView.camera.zoom - 1)
            })
            .disposed(by: self.disposeBag)
        
        myLocationButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                guard let coordinates = weakSelf.locationService.getLocation() else { return }
                let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: weakSelf.mapView.camera.zoom)
                weakSelf.mapView.camera = camera
                weakSelf.mapView.animate(to: camera)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createMap() {
        mapView = GMSMapView(frame: self.view.frame)
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
            let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: mapView.camera.zoom)
            mapView.camera = camera
            createMarker(for: coordinates)
            mapView.animate(to: camera)
            myLocationButton.setImage(UIImage(named: Const.myLocationImageName), for: .normal)
        case .notDetermined:
            locationService.getLocation()
        case .restricted, .denied:
            visualEffectView.alpha = 0
            myLocationButton.setImage(UIImage(named: Const.offLocationImagename), for: .normal)
        default:
            break
        }
    }
    
    func checkStatusGivenVersion() {
        checkStatus(didChangeAuthorization: locationService.status())
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        interactor.handlePinTap(pin: marker)
        mapView.selectedMarker = marker
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
        }, completion: { _ in
            desiredView.isHidden = true
        })
    }
    
    private func setPopUpView(with model: ATMDetailsPopUpViewModel, data: DepartmentsResponse) {
        popUp = {
            let popup = ATMDetailsPopUpView()
            popup.isHidden = true
            popup.delegate = self
            return popup
        }()
        
        self.view.addSubview(popUp)
        popUp.snp.remakeConstraints { make in
            make.leading.equalTo(25)
            make.trailing.equalToSuperview().offset(-25)
            make.bottom.equalToSuperview().offset(-30)
        }
        popUp.fill(with: model, data: data)
        popUp.addGestureRecognizer(doubleTapOnPopup)
    }
}

extension ATMsViewController: PullUpATMsServiceDelegate {
    func didSelectService(service: NameService) {
        self.interactor.didSelectService(service: service)
    }
}

extension ATMsViewController: ATMsPresentorOutput {
    func displayData(sections: [ATMsSectionDataSource]) {
        self.pullUpContainer.transferData(sections: sections)
    }
    
    private func changeSelectedPinIcon(setSelect: Bool, department: DepartmentsResponse, pin: GMSMarker) {
        let imageName = setSelect ? checkType(department: department) + "_selected" : checkType(department: department)
        pin.iconView = UIImageView(image: UIImage(named: imageName))
    }
    
    private func zoomInForSelectedPin(pin: GMSMarker) {
        let camera = GMSCameraPosition.camera(withLatitude: pin.position.latitude, longitude: pin.position.longitude, zoom: mapView.camera.zoom < 10 ? 10 : mapView.camera.zoom)
        mapView.camera = camera
        mapView.animate(to: camera)
    }
    
    private func handleMapDisplayChange(department: DepartmentsResponse, isPopupOpen: Bool) {
        let coordinateComponents = department.coordinates.components(separatedBy: ", ")
        guard coordinateComponents.count >= 2, let latitude = Double(coordinateComponents[0]), let longitude = Double(coordinateComponents[1]), let selectedMarker = mapView.selectedMarker ?? markers.first(where: { marker in
            marker.position.latitude == latitude && marker.position.longitude == longitude
        }) else {
            return
        }
        changeSelectedPinIcon(setSelect: isPopupOpen, department: department, pin: selectedMarker)
        zoomInForSelectedPin(pin: selectedMarker)
    }
    
    func displayPopUp(with model: ATMDetailsPopUpViewModel, data: DepartmentsResponse) {
        setPopUpView(with: model, data: data)
        handleMapDisplayChange(department: data, isPopupOpen: true)
        animateScaleIn(desiredView: popUp)
        randomTapHandlerView.isHidden = false
        pullUpContainer.view.isHidden = true
        doubleTapOnPopup.isEnabled = true
        randomTap.isEnabled = true
        
        randomTap
            .rx
            .event
            .withUnretained(self)
            .bind(onNext: { weakSelf, _ in
            weakSelf.handleCloseButton(department: data)
        }).disposed(by: disposeBag)
        
        doubleTapOnPopup
            .rx
            .event
            .withUnretained(self)
            .bind(onNext: { weakSelf, _ in
            weakSelf.handleCloseButton(department: data)
        }).disposed(by: disposeBag)
    }
    
    func displayDepartmentsForPins(departments: [DepartmentsResponse]) {
        guard let coordinates = locationService.getLocation() else { return}
        self.mapView.clear()
        self.createMarker(for: coordinates)
        self.displayPins(departments: departments)
    }
}

extension ATMsViewController: ATMDetailsPopUpViewDelegate {
    func handleCloseButton(department: DepartmentsResponse) {
        animateScaleOut(desiredView: popUp)
        handleMapDisplayChange(department: department, isPopupOpen: false)
        mapView.selectedMarker = nil
        randomTapHandlerView.isHidden = true
        pullUpContainer.view.isHidden = false
        doubleTapOnPopup.isEnabled = false
        randomTap.isEnabled = false
    }
    
    func handleSeeDetailsButton(department: DepartmentsResponse) {
        router.navigateToDepartment(department: department)
    }
}

extension ATMsViewController: ATMsSegmentedPresentorOutput {
    func displayDepartments(departments: [DepartmentsResponse]) {
        interactor.setDepartments(departments: departments)
    }
}

extension ATMsViewController: ATMsSegmentedControllerChildDelegate {
    func displayPopup(for department: DepartmentsResponse) {
        interactor.displayPopup(for: department)
    }
}
