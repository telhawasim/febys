//
//  febysLabel.swift
//  febys
//
//  Created by Waseem Nasir on 26/06/2021.
//

import UIKit

/// febysLabel to provide option for line height in text
@IBDesignable
class FebysLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    
    /// line height to be set for text in label
    @IBInspectable
    var lineHeight : CGFloat = 17 {
        didSet {
//            setLineHeight(height: lineHeight)
        }
    }
    
    @IBInspectable
    var letterSpacing : Double = 0 {
        didSet {
            addCharacterSpacing(kernValue: letterSpacing)
        }
    }
    
//    @IBInspectable
//    var localizeTextKey: String = "" {
//        didSet {
//            self.text = localizeTextKey.localized
//        }
//    }
    
    @IBInspectable
    var alwaysCapital: Bool = false {
        didSet {
            trySetTextUppercase()
        }
    }
    
    
    override var text: String? {
        didSet {
            trySetTextUppercase()
        }
    }
    
    
    private func trySetTextUppercase() {
        if text == nil {
            return
        }
        if alwaysCapital {
            text = text!.uppercased()
        }
    }
    override func prepareForInterfaceBuilder() {
//        self.text = localizeTextKey.localized
        trySetTextUppercase()
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
    
    func strikeThrough(_ isStrikeThrough: Bool) {
        if isStrikeThrough {
            if let lblText = self.text {
                let attributeString =  NSMutableAttributedString(string: lblText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        } else {
            if let attributedStringText = self.attributedText {
                let txt = attributedStringText.string
                self.attributedText = nil
                self.text = txt
                return
            }
        }
    }
}

extension FebysLabel {
    func animate(duration: TimeInterval) {
        let oldTransform = transform
        transform = transform.scaledBy(x: 1.1, y: 1.1)
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            self.transform = oldTransform
            self.layoutIfNeeded()
        }
    }
}
