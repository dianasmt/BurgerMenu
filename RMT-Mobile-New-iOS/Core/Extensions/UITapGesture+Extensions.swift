//
//  UITapGesture+Extensions.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 02.09.2022.
//

import UIKit

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel,
                                     inRange targetRange: NSRange,
                                     isMultipleLines: Bool = false,
                                     textAlignment: NSTextAlignment = .center) -> Bool {
        
        guard let attributedText = label.attributedText else { return false }

        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        var textStorage = NSTextStorage(attributedString: attributedText)
        
        // Multiple-lined labels are not working properly without this code
        if isMultipleLines {
            let mutableStr = NSMutableAttributedString.init(attributedString: attributedText)
            guard let font = label.font else { return false }
            mutableStr.addAttributes([NSAttributedString.Key.font: font],
                                     range: NSRange.init(location: 0, length: attributedText.length))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            mutableStr.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle],
                                     range: NSRange(location: 0, length: attributedText.length))
            textStorage = NSTextStorage(attributedString: mutableStr)
        }
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer) // label.bounds
        let textContainerX = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
        let textContainerY = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint(x: textContainerX, y: textContainerY)
        
        let locationX = locationOfTouchInLabel.x - textContainerOffset.x
        let locationY = locationOfTouchInLabel.y - textContainerOffset.y
        let locationOfTouchInTextContainer = CGPoint(x: locationX, y: locationY)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
