//
//  MenuPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 25.07.22.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol MenuPresentorOutput: AnyObject {
    func displayData(sections: [SectionDataSource])
    func displayPhoneDialer(number: String)
}

final class MenuPresenter {
    weak var viewController: MenuPresentorOutput?
    init(viewController: MenuPresentorOutput) {
        self.viewController = viewController
    }
}

extension MenuPresenter: MenuInteractorOutput {
    func displaySections(sections: [SectionDataSource]) {
        self.viewController?.displayData(sections: sections)
    }
    
    func displayPhoneDialer(number: String) {
        self.viewController?.displayPhoneDialer(number: number)
    }
}
