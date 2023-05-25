//
//  AppStoryboards.swift
//  febys
//
//  Created by Waseem Nasir on 26/06/2021.
//


import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func rotate(angleInDegrees: DegreeAngle) {
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform(rotationAngle: .pi * angleInDegrees.rawValue)
        }
    }
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension UIView {
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        return contentView
    }
}

enum DegreeAngle: CGFloat {
    case angle90 = 0.5
    case angle180 = 1.0
    case angle270 = 1.5
    case angle360 = 2.0
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}

extension Notification.Name {
    static let userProfileChanged = Notification.Name(rawValue: "userProfileChanged")
    static let requestAcceptedByPhotographer = Notification.Name(rawValue: "requestAcceptedByPhotographer")
    static let minFeetAchievedLandmarkPhotographer = Notification.Name(rawValue: "minFeetAchievedLandmarkPhotographer")
    static let sessionStart = Notification.Name(rawValue: "sessionStart")
    static let minNotFeetAchievedLandmarkPhotographer = Notification.Name(rawValue: "minNotFeetAchievedLandmarkPhotographer")
    
    static let updatedPhotoStatusInPrivate = Notification.Name("updatedPhotoStatusInPrivate")
    static let updatedPhotoStatusInSocial = Notification.Name("updatedPhotoStatusInSocial")
    static let updatePhotoInAllPhotos = Notification.Name("updatePhotoInAllPhotos")
    static let internetConnected = Notification.Name("InternetConnected")
}

class Toast {
    class func show(message : String) {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let toastLabel = UILabel(frame: CGRect(x: appDelegate.window!.frame.size.width/2 - 110, y: appDelegate.window!.frame.size.height-100, width: 220, height: 40))
//        let toastLabel = UILabel()
        toastLabel.backgroundColor = #colorLiteral(red: 1, green: 0.5098039216, blue: 0.2196078431, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.sizeToFit()
        toastLabel.font = UIFont(name: "Nunito-Bold", size: 12.0)
        toastLabel.text = message
//        toastLabel.sizeToFit()
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 20;
        toastLabel.clipsToBounds  =  true
        
        appDelegate.window!.addSubview(toastLabel)
        
        UIView.animate(withDuration: 4.0, delay: 0.0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }
}
