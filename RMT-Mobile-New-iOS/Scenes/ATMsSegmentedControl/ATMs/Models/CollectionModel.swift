//
//  CollectionModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 7.09.22.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol ATMsCellProtocol {
    var title: String { get }
    var image: String { get }
}

struct ATMsCollectionModel: ATMsCellProtocol {
    var title: String
    var image: String
    var nameService: NameService
}

struct ATMsSectionDataSource {
    var title: String
    var items: [Item]
}

extension ATMsSectionDataSource: SectionModelType {
    typealias Item = ATMsCollectionModel
    
    init(original: ATMsSectionDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}

struct ATMServicesCollectionViewCellModel {
    let imageName: String
}

struct ATMServicesSectionDataSource {
    var items: [ATMServicesCollectionViewCellModel]
}

extension ATMServicesSectionDataSource: SectionModelType {
    init(original: ATMServicesSectionDataSource, items: [ATMServicesCollectionViewCellModel]) {
        self = original
        self.items = items
    }
}
