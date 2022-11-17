//
// LanguageButton.swift
// RMT-Mobile-New-iOS
//

import UIKit

final class LanguageButton: UIButton {
    
    // MARK: - Properties
    let language: Languages
    
    // MARK: - Initializer
    init(with language: Languages) {
        self.language = language
        super.init(frame: .zero)
        self.setupUI()
        self.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func updateUI(for language: Languages = Languages.current) {
        language == self.language ? self.setSelected() : self.setDeselected()
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 4 * Constants.screenFactor
        self.titleLabel?.font = .fontSFProText(type: .semibold, size: 17 * Constants.screenFactor)
    }
    
    private func setSelected() {
        self.backgroundColor = .customYellow
        self.setTitleColor(.customBlack, for: .normal)
    }
    
    private func setDeselected() {
        self.backgroundColor = .none
        self.setTitleColor(.customGray, for: .normal)
    }
}
