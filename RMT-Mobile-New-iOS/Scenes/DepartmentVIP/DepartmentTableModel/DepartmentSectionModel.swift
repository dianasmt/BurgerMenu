//
//  DepartmentTableCells.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 13.09.2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

struct DepartmentSectionDataSource {
    var items: [DepartmentCellProtocol]
}

extension DepartmentSectionDataSource: SectionModelType {
    init(original: DepartmentSectionDataSource, items: [DepartmentCellProtocol]) {
        self = original
        self.items = items
    }
}

struct WeekdaysSectionDataSource {
    var items: [WeekdayCellProtocol]
}

extension WeekdaysSectionDataSource: SectionModelType {
    init(original: WeekdaysSectionDataSource, items: [WeekdayCellProtocol]) {
        self = original
        self.items = items
    }
}
