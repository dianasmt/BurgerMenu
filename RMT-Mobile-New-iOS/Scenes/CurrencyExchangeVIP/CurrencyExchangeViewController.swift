//
//  CurrencyExchangeViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 11.08.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class CurrencyExchangeViewController: BaseViewController {
    
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "burger_menu_exchange_rates"
    }
    
    // MARK: - Properties
    var interactor: CurrencyExchangeInteractor!
    private let disposeBag = DisposeBag()
    
    // MARK: - Override properties
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    // MARK: - Outlets
    private lazy var currencyTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.separatorInset = .zero
        table.allowsSelection = false
        table.rowHeight = 60
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.className)
        return table
    }()
    
    private lazy var currencyHeaderView: CurrencyHeaderView = {
        let view = CurrencyHeaderView()
        let header = CurrencyHeaderModel(currencyTitle: .localString(stringKey: CurrencyExchangeInteractor.Const.currencyName),
                                         buyTitle: .localString(stringKey: CurrencyExchangeInteractor.Const.currencyBuyTitle),
                                         sellTitle: .localString(stringKey: CurrencyExchangeInteractor.Const.currencySellTitle))
        view.updateUI(model: header)
        return view
    }()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupLayouts()
        interactor.loadExchangeRates()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        [currencyHeaderView, currencyTableView].forEach { view.addSubview($0) }
    }
    
    private func setupLayouts(){
        currencyHeaderView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(60)
        }
        
        currencyTableView.snp.makeConstraints { maker in
            maker.top.equalTo(currencyHeaderView.snp.bottom)
            maker.left.right.bottom.equalToSuperview()
        }
    }
}

extension CurrencyExchangeViewController: CurrencyExchangePresentorOutput {
    func displayData(cells: [CurrencyDataSource]) {
        let dataSource = RxTableViewSectionedReloadDataSource<CurrencyDataSource>(
            configureCell: { datasource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.className, for: indexPath)
                cell.fill(with: item)
                return cell
            })
        Observable.just(cells)
            .bind(to: currencyTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
