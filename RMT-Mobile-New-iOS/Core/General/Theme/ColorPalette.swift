//
//  ColorPalette.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 05.09.2022.
//

import Foundation
import UIKit

struct ColorPalette {
    let customBackgrounColor: UIColor
    let registerButtonTitleColor: UIColor
    let registerButtonBorderColor: UIColor
    let customLabel: UIColor
    let burgerMenuIconColor: UIColor
    let burgerMenuSpecialLabelColor: UIColor
    let bottomDividerColor: UIColor
    let burgerMenuTableSeparatorColor: UIColor
    let textViewBackgroundColor: UIColor
    let controlViewBackgroundColor: UIColor
    let containerCellBackgroundColor: UIColor
    
    static let light: ColorPalette = .init(
        customBackgrounColor: .white,
        registerButtonTitleColor: .customBlack,
        registerButtonBorderColor: .customYellow,
        customLabel: .black,
        burgerMenuIconColor: .black,
        burgerMenuSpecialLabelColor: .customGray,
        bottomDividerColor: .customSeparator,
        burgerMenuTableSeparatorColor: .customSeparator,
        textViewBackgroundColor: .white,
        controlViewBackgroundColor: .lightGreyColor,
        containerCellBackgroundColor: .lightGreyColor
    )

    static let dark: ColorPalette = .init(
        customBackgrounColor: .customBackgrounDark,
        registerButtonTitleColor: .white,
        registerButtonBorderColor: .secondaryGray,
        customLabel: .white,
        burgerMenuIconColor: .customGray,
        burgerMenuSpecialLabelColor: .white,
        bottomDividerColor: .black,
        burgerMenuTableSeparatorColor: .secondaryGray,
        textViewBackgroundColor: .customLighterGray,
        controlViewBackgroundColor: .customBackgrounDark,
        containerCellBackgroundColor: .grayishBlack
    )
}
