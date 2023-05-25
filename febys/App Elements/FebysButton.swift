//
//  FebysButton.swift
//  febys
//
//  Created by Waseem Nasir on 26/06/2021.
//

import UIKit

/// FebysButton to provide option for letter spacing
@IBDesignable
class FebysButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isEnabled = Bool(isEnabled)
        self.layer.cornerRadius = 5
        addSelfOnClickListner()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isEnabled = Bool(isEnabled)
        self.layer.cornerRadius = 5
        addSelfOnClickListner()
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.alpha = 1
            }
            else {
                self.alpha = 0.5
            }
        }
    }
    
    /// letter spacing to be set to text in button
    @IBInspectable
    var letterSpacing : Double = 0.23 {
        didSet {
            self.titleLabel?.addCharacterSpacing(kernValue: letterSpacing)
        }
    }
    
    @IBInspectable
    var alwaysCapital: Bool = false {
        didSet {
            trySetTextUppercase(self.currentTitle, for: state)
        }
    }
    
    
    private func trySetTextUppercase(_ text: String?, for state: UIControl.State) {
        if text == nil || !alwaysCapital {
            return
        }
        setTitle(text!.uppercased(), for: .normal)
        setTitle(text!.uppercased(), for: .selected)
        setTitle(text!.uppercased(), for: .disabled)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        trySetTextUppercase(title, for: state)
    }
    
    var didTap: (()->Void)?
    
    func addSelfOnClickListner() {
        self.addTarget(self, action: #selector(didTapSelf(_:)), for: .touchUpInside)
    }
    
    @IBAction private func didTapSelf(_ sender: UIButton) {
        self.didTap?()
    }
}

extension FebysButton {    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

class CustomFollowButton: FebysButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setBackgroundColor(color: .clear, forState: .normal)
        self.setBackgroundColor(color: .febysRed(), forState: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setBackgroundColor(color: .clear, forState: .normal)
        self.setBackgroundColor(color: .febysRed(), forState: .selected)
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected
            ? (self.setBorder(width: 1, color: .febysBlack()))
            : (self.setBorder(width: 0.0, color: .clear))
        }
    }
    
    private func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }

}
