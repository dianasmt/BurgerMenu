//
//  UserRequestViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08.08.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class UserRequestViewController: BaseViewController {
    enum Const {
        static let titleLabelName = "ATMs_title_menu"
    }
    
    var router: UserRequestViewRoutingLogic?
    var interactor: UserRequestInteractor?
    private let disposeBag = DisposeBag()
    
    private lazy var infoTitleLabel: UILabel = {
        let label = UILabel()
        let text: String = .localString(stringKey: UserRequestInteractor.Const.titleKey)
        label.text = text
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .fontSFProText(type: .bold, size: 24)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        let text: String = .localString(stringKey: UserRequestInteractor.Const.descriptionKey)
        label.text = text
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = .fontSFProText(type: .regular, size: 14)
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        guard let image = UIImage(named: UserRequestInteractor.Const.imageName) else { return imageView }
        imageView.image = image
        return imageView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        let text: String = .localString(stringKey: UserRequestInteractor.Const.titleButtonKey)
        
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .fontSFProText(type: .bold, size: 16)
        button.setTitleColor(.customBlack, for: .normal)
        button.backgroundColor = .customYellow
        button.layer.cornerRadius = 6
        return button
    }()
    
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayouts()
        setupBindings()
    }
    
    private func addSubviews() {
        [infoTitleLabel, descriptionLabel, imageView, continueButton].forEach { view.addSubview($0) }
    }
    
    private func setupLayouts() {
        
        infoTitleLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(35)
            maker.width.equalTo(344)
            maker.height.equalTo(72)
            maker.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(infoTitleLabel.snp.bottom).inset(-25)
            maker.width.equalTo(343)
            maker.left.equalTo(16)
            maker.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).inset(-74)
            maker.width.equalTo(304)
            maker.height.equalTo(284)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(continueButton.snp.top).inset(-40)
        }
        continueButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(60)
            maker.width.equalTo(345)
            maker.bottom.equalToSuperview().inset(57)
        }
    }
    
    private func setupBindings() {
        continueButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.router?.navigateToATMs()
                UserDefaults.isNotFirstTime = true
            })
            .disposed(by: self.disposeBag)
    }
    
    func updateUI(page: PageModel) {
        imageView.image = UIImage(named: page.imageName)
        infoTitleLabel.text = page.label
        descriptionLabel.text = page.extralabel
    }
}

extension UserRequestViewController: UserRequestPresentorOutput {
}
