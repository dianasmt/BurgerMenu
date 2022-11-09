//
//  ChangeLangModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 4.08.22.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

struct LanguageModel {
    var title: String
    var icon: String
    var language: Languages
}

struct LanguageDataSource {
    var items: [LanguageModel]
}

extension LanguageDataSource: SectionModelType {
    init(original: LanguageDataSource, items: [LanguageModel]) {
        self = original
        self.items = items
    }
}
