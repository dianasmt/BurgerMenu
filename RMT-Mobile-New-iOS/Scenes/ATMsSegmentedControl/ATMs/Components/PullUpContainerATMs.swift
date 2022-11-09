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

protocol PullUpATMsServiceDelegate {
    func didSelectService(service: NameService)
}

class PullUpContainerATMs: PullUpContainer, UICollectionViewDelegateFlowLayout {
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let columnLayout = CustomViewFlowLayout()
        columnLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        columnLayout.headerReferenceSize = CGSize(width: self.contentContainerView.frame.width, height: 30)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: columnLayout)
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.register(PullUpCollectionViewCell.self,
                                forCellWithReuseIdentifier: PullUpCollectionViewCell.className)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.className)
        return collectionView
    }()
    
    private var delegate: ATMsViewController?
  
    init(frame: CGRect, delegate: PullUpATMsServiceDelegate?) {
        super.init(frame: frame)
        contentContainerView.addSubview(collectionView)
        setUpCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCollectionView() {
        collectionView.stretchLayout()
        setUpBindings()
    }
    
    private func setUpBindings() {
        collectionView
            .rx
            .modelSelected(ATMsCollectionModel.self)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, item in
                print("SERVICE \(item.nameService.rawValue)")
                weakSelf.delegate?.didSelectService(service: item.nameService)
            })
            .disposed(by: disposeBag)
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
    }
}
