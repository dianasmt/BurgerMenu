//
//  UserRequestPresenter.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 08.08.2022.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

protocol UserRequestPresentorOutput: AnyObject {
}

final class UserRequestPresenter {
    weak var viewController: UserRequestPresentorOutput?
    
    init(viewController: UserRequestPresentorOutput) {
        self.viewController = viewController
    }
}

extension UserRequestPresenter: UserRequestInteractorOutput {
}
