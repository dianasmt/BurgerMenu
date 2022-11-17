//
//  MenuViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 25.07.22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MenuViewController: BaseViewController {
    
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "burger_menu_title_menu"
    }
    
    // MARK: - Properties
    var router: MenuRoutingLogic?
    var interactor: MenuInteractorInput?
    private let disposeBag = DisposeBag()
    private let defaults = UserDefaults.standard
    
    // MARK: - Override properties
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    // MARK: - Outlets
    private lazy var burgerMenuTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.className)
        table.register(ImageTitleTableViewCell.self, forCellReuseIdentifier: ImageTitleTableViewCell.className)
        table.register(ChangeLangTableViewCell.self, forCellReuseIdentifier: ChangeLangTableViewCell.className)
        return table
    }()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        interactor?.presentInitialData()
        handleClicking()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changingLanguage), name: .languageChanged, object: nil)
    }
    
    @objc func changingLanguage() {
        self.burgerMenuTableView.reloadData()
    }
    
    // MARK: - Methods
    private func setUpTableView() {
        view.addSubview(burgerMenuTableView)
        burgerMenuTableView.frame = view.bounds
        burgerMenuTableView.delegate = self
    }
    
    private func handleClicking() {
        burgerMenuTableView.rx
            .modelSelected(BurgerMenuCellProtocol.self)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, value in
                switch value.type {
                case .ATMs:
                    if UserDefaults.isNotFirstTime {
                        weakSelf.router?.navigateToATMs()
                    } else {
                        weakSelf.router?.navigateToRequestLocation()
                    }
                case .exchangeRates:
                    weakSelf.router?.navigateToCurrencyExchange()
                case .polandNumber:
                    weakSelf.interactor?.clickOnNumber(number: value.title)
                case .number:
                    weakSelf.interactor?.clickOnNumber(number: value.title)
                case .errorReport:
                    weakSelf.router?.navigateToErrorReport()
                case .language:
                    weakSelf.router?.navigateToChangeLang()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return BurgerFooterView(offset: .upper)
        case 2, 3:
            return BurgerFooterView(offset: .none)
        default:
            return BurgerFooterView(offset: .both)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

extension MenuViewController: MenuPresentorOutput {
    func displayData(sections: [SectionDataSource]) {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionDataSource>(
            configureCell: { _, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseIdentifier, for: indexPath)
                cell.fill(with: item)
                return cell
            })
        Observable.just(sections)
            .bind(to: burgerMenuTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func displayPhoneDialer(number: String) {
        let app = UIApplication.shared
        guard let dialerURL = URL(string: "tel://\(number)"), app.canOpenURL(dialerURL) else {
            return
        }
        app.open(dialerURL)
    }
}
