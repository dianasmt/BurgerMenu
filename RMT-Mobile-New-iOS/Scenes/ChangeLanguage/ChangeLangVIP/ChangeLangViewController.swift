//
//  ChangeLangViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 4.08.22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class ChangeLangViewController: BaseViewController {
    
    // MARK: - Consts
    enum Const {
        static let titleLabelName = "burger_menu_language" 
    }

    // MARK: - Properties
    var interactor: ChangeLangInteractorInput!
    private let disposeBag = DisposeBag()
    
    // MARK: - Override properties
    override var isHeaderHidden: Bool { return false }
    override var titleLabel: String? { return .localString(stringKey: Const.titleLabelName) }
    
    // MARK: - Outlets
    private lazy var changeLangTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(LanguageTableViewCell.self, forCellReuseIdentifier: LanguageTableViewCell.className)
        return table
    }()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        interactor.presentInitialData()
        handleClicking()
    }
    
    // MARK: - Methods
    private func setUpTableView() {
        view.addSubview(changeLangTableView)
        changeLangTableView.frame = view.bounds
        changeLangTableView.delegate = self
    }
    
    private func handleClicking() {
        changeLangTableView.rx
            .modelSelected(LanguageModel.self)
            .withUnretained(self)
            .subscribe(onNext:  { weakSelf, value in
                weakSelf.interactor.changeLanguage(language: value.language)
                weakSelf.changeLangTableView.reloadData()
                weakSelf.delegate?.updateUI(controller: weakSelf)
            })
            .disposed(by: disposeBag)
    }
}

extension ChangeLangViewController: ChangeLangPresentorOutput {
    func displayData(languages: [LanguageDataSource]) {
        let dataSource = RxTableViewSectionedReloadDataSource<LanguageDataSource>(
            configureCell: { datasource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.className, for: indexPath)
                cell.fill(with: item)
                return cell
            })
        Observable.just(languages)
              .bind(to: changeLangTableView.rx.items(dataSource: dataSource))
              .disposed(by: disposeBag)
    }
}

extension ChangeLangViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
