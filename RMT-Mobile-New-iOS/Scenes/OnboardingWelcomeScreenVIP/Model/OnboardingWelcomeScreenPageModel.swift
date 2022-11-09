//
//  OnboardingWelcomeScreenPageModel.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 03.08.2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

protocol OnboardingWelcomeScreenCellProtocol {
    var reuseIdentifier: String { get }
    var imageName: String { get }
    var label: String { get }
    var extralabel: String { get }
}

struct PageModel: OnboardingWelcomeScreenCellProtocol {
    var reuseIdentifier: String
    let imageName: String
    let label: String
    let extralabel: String
}

struct PagesDataSource {
    var items: [OnboardingWelcomeScreenCellProtocol]
}

extension PagesDataSource: SectionModelType {
    init(original: PagesDataSource, items: [OnboardingWelcomeScreenCellProtocol]) {
        self = original
        self.items = items
    }
}
 
