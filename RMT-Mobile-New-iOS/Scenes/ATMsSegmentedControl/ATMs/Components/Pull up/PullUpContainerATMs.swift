//
//  PullUpContainerATMs.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 30.08.22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol ATMsViewControllerOut {
    func transferData(sections: [ATMsSectionDataSource])
}

class PullUpContainerATMs: StickyPullUpController, UICollectionViewDelegateFlowLayout {
    private let disposeBag = DisposeBag()

    var delegate: ATMsViewController?

    private enum Consts {
        static let moreFilters = "atm_pull_up_more_filters"
    }
    
    private lazy var collectionView: UICollectionView = {
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        columnLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 30)
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: columnLayout)
        collectionView.register(PullUpCollectionViewCell.self,
                                forCellWithReuseIdentifier: PullUpCollectionViewCell.className)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.className)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private let headerContainerView = UIView()
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGreyColor
        view.layer.cornerRadius = 2
        return view
    }()
    
    private lazy var moreFiltersButton: UIButton = {
        let button = UIButton()
        button.setTitle(.localString(stringKey: Consts.moreFilters), for: .normal)
        button.titleLabel?.font = .fontSFProText(type: .semibold, size: 16)
        button.setTitleColor(.customBackgrounDark, for: .normal)
        return button
    }()
  
    static func make() -> PullUpContainerATMs {
        return PullUpContainerATMs(nibName: String(describing: PullUpContainerATMs.self), bundle: nil)
    }
    
    var height: CGFloat = 0
    
    // MARK: - Override
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200 * Constants.screenFactor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSubviews()
        self.setupBindings()
        themeProvider.register(observer: self)
    }
    
    // MARK: - Methods
    private func addSubviews() {
        self.view.layer.cornerRadius = 12
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.view.addSubview(self.headerContainerView)
        self.headerContainerView.addSubview(self.topLineView)
        self.view.addSubview(moreFiltersButton)
        self.headerContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50 * Constants.screenFactor)
        }
        
        self.topLineView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(5 * Constants.screenFactor)
            make.width.equalTo(30 * Constants.screenFactor)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.headerContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        self.collectionView.attach(to: self)
        
        self.moreFiltersButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        self.headerContainerView.rx
            .tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.handleTap()
            })
            .disposed(by: self.disposeBag)

        collectionView
            .rx
            .modelSelected(ATMsCollectionModel.self)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, item in
                weakSelf.delegate?.didSelectService(service: item.nameService)
            })
            .disposed(by: disposeBag)
        
        collectionView
            .rx
            .modelDeselected(ATMsCollectionModel.self)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, item in
                weakSelf.delegate?.didSelectService(service: item.nameService)
            })
            .disposed(by: disposeBag)

        self.moreFiltersButton.rx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, _ in
                weakSelf.handleTap()
            })
            .disposed(by: self.disposeBag)
    }
    
    override var onDrag: ((CGFloat) -> Void)? {
        get { return { point in
            if point > (self.minPullupHeight ?? 100) && self.offset == .min {
                self.offset = .min
                self.handleTap()
            } else if point > (self.minPullupHeight ?? 100) && self.offset == .max && point < (self.maxPullupHeight ?? 400) {
                self.offset = .max
                self.handleTap()
            } else if point > (self.maxPullupHeight ?? 400) && self.offset == .max {
                self.offset = .min
                self.handleTap()
            }
        }
        }
        set {}
    }
    
    private(set) var maxPullupHeight: CGFloat?
    private(set) var minPullupHeight: CGFloat?
    private var maxCollectionViewHeight: CGFloat?
    private var minCollectionViewHeight: CGFloat?
    private var offset: Offset = .max
    private enum Offset {
        case min
        case max
    }
}

extension PullUpContainerATMs: ATMsViewControllerOut {
    func transferData(sections: [ATMsSectionDataSource]) {
        let dataSource = RxCollectionViewSectionedReloadDataSource<ATMsSectionDataSource>(
            configureCell: { datasource, collectioView, indexPath, item in
                guard let cell = collectioView.dequeueReusableCell(withReuseIdentifier: PullUpCollectionViewCell.className, for: indexPath) as? PullUpCollectionViewCell else { return PullUpCollectionViewCell() }
                cell.fill(with: item)
                return cell
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.className, for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
            header.configure(with: sections[indexPath.section].title)
             return header
         }
        
        Observable.just(sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.reloadData()
        collectionView.layoutSubviews()
        
        let itemsInSection1 = self.collectionView.numberOfItems(inSection: 0)
        let itemsInSection3 = self.collectionView.numberOfItems(inSection: 2)
        let section1LastCell = self.collectionView.cellForItem(at: IndexPath(item: itemsInSection1 - 1, section: 0))
        let section3lastCell = self.collectionView.cellForItem(at: IndexPath(item: itemsInSection3 - 1, section: 2))
        
        self.maxCollectionViewHeight = section3lastCell?.frame.maxY
        self.minCollectionViewHeight = section1LastCell?.frame.maxY
        self.maxPullupHeight = (section3lastCell?.frame.maxY ?? 400) + 50 + 19.5
        self.minPullupHeight = (section1LastCell?.frame.maxY ?? 100) + 50 + 48 + 19.5
        handleTap()
    }
    
    private func handleTap() {
        if self.offset == .min {
            self.offset = .max
        } else {
            self.offset = .min
        }
        
        switch self.offset {
        case .min:
            self.collectionView.snp.remakeConstraints { make in
                make.top.equalTo(self.headerContainerView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo((self.minCollectionViewHeight ?? 100))
            }
            self.moreFiltersButton.isHidden = false
            pullUpControllerMoveToVisiblePoint((minPullupHeight ?? 100), animated: true, completion: nil)
        case .max:
            self.collectionView.snp.remakeConstraints { make in
                make.top.equalTo(self.headerContainerView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(self.maxCollectionViewHeight ?? 400)
            }
            self.moreFiltersButton.isHidden = true
            pullUpControllerMoveToVisiblePoint((maxPullupHeight ?? 400), animated: true, completion: nil)
        }
    }
}

extension PullUpContainerATMs: Themeable {
    func setupTheme(theme: Theme) {
        view.backgroundColor = theme.colors.customBackgrounColor
        moreFiltersButton.setTitleColor(theme.colors.customLabel, for: .normal)
        collectionView.backgroundColor = theme.colors.customBackgrounColor
    }
}
