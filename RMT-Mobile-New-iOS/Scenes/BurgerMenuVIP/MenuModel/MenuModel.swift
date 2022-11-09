//
//  MenuModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 25.07.22.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol BurgerMenuCellProtocol {
    var reuseIdentifier: String { get }
    var title: String { get }
    var image: String { get }
    var type: BurgerMenuCellType { get }
}

enum BurgerMenuCellType {
    case ATMs
    case exchangeRates
    case polandNumber
    case number
    case errorReport
    case language
    case darkMode
}

struct CellModel: BurgerMenuCellProtocol {
    var reuseIdentifier: String
    let title: String
    let subTitle: String
    let image: String
    let type: BurgerMenuCellType
}

struct SwitchCellModel: BurgerMenuCellProtocol {
    var reuseIdentifier: String
    let title: String
    let image: String
    let switcherIsOn: Bool
    let type: BurgerMenuCellType
}

struct ChangeLangCellModel: BurgerMenuCellProtocol {
    var reuseIdentifier: String
    let title: String
    let image: String
    let language: String
    let type: BurgerMenuCellType
}

struct SectionDataSource {
    var items: [BurgerMenuCellProtocol]
}

extension SectionDataSource: SectionModelType {
    init(original: SectionDataSource, items: [BurgerMenuCellProtocol]) {
        self = original
        self.items = items
    }
}
