//
//  FebysTextField.swift
//  febys
//
//  Created by Waseem Nasir on 27/06/2021.
//

import UIKit
import PhoneNumberKit

/// FebysTextField to provide option for letter spacing
@IBDesignable
class FebysTextField: UITextField {
    
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
    
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return leftView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            leftView = paddingView
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get {
            return rightView?.frame.size.width ?? 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.alpha = 1
            }
            else {
                self.alpha = 0.7
            }
        }
    }
    
    //    /// placeholder for underline field
//    @IBInspectable
//    open var placeholder: String? {
//        set {
//            placeholderLabel. = newValue
//        }
//        get {
//            return haUnderlineField?.textField.placeholder
//        }
//    }
//
//    /// label for displaying placeholder
//    lazy var placeholderLabel: FebysLabel = {
//        let label = FebysLabel()
//        label.font = self.font
//        label.translatesAutoresizingMaskIntoConstraints = false
//        neededConstraint.append(NSLayoutConstraint(item: label,
//                                                   attribute: .leading,
//                                                   relatedBy: .equal,
//                                                   toItem: self,
//                                                   attribute: .leading,
//                                                   multiplier: 1,
//                                                   constant: 24))
//        self.placeholderYConstraint = NSLayoutConstraint(item: label,
//                                                         attribute: .centerY,
//                                                         relatedBy: .equal,
//                                                         toItem: self,
//                                                         attribute: .centerY,
//                                                         multiplier: 1,
//                                                         constant: 0)
//
//        neededConstraint.append(placeholderYConstraint)
//
//        return label
//    }()
    
    var didChangeText : ((String)->Void)?
    
    func addSelfOnClickListner() {
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange() {
        if self.isSecureTextEntry {
            text = text?.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        
        didChangeText?(text ?? "")
    }
    
}

extension UITextField{
    func setBorderColor(width:CGFloat,color:UIColor) -> Void{
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}
