//
//  UIColor.swift
//  febys
//
//  Created by Waseem Nasir on 27/06/2021.
//

import UIKit

extension UIColor {
    
    /// Creates and returns HelveticaNeue font with given style
    ///
    /// Trys to create a font with `Helvetica Neue` style given. If font style is not found it create an object with font size
    /// - Parameter font: a value of type `Helvetica Neue` to get HelveticaNeue font of that type
    /// - Parameter size: size of font to be returned
    /// - Returns : UIFont with given font style
    static func febysBlack() -> UIColor {
        return UIColor(named: "BlackMainColor")!
    }
    
    static func febysGray() -> UIColor {
        return UIColor(named: "GrayMainColor")!
    }
    
    static func febysRed() -> UIColor {
        return UIColor(named: "RedMainColor")!
    }
    
    static func febysLightGray() -> UIColor {
        return UIColor(named: "LightGrayColor")!
    }
    
    static func febysMildGreyColor() -> UIColor {
        return UIColor(named: "MildGreyColor")!
    }
    
    static func febysLightRed() -> UIColor {
        return UIColor(named: "LightRed")!
    }
    
    static func febysLightGreen() -> UIColor {
        return UIColor(named: "LightGreen")!
    }
    
    static func febysLightBlue() -> UIColor {
        return UIColor(named: "LightBlue")!
    }
    
    static func febysDisableGrey() -> UIColor {
        return UIColor(named: "DisableGreyColor")!
    }
    
    static func febysDisableDarkGrey() -> UIColor {
        return UIColor(named: "DisableDarkGreyColor")!
    }
    
    static func febysSkyBlue() -> UIColor {
        return UIColor(named: "SkyBlueColor")!
    }
    
    static func statusGrey() -> UIColor {
        return UIColor(named: "Grey-Status")!
    }
    
    static func statusBlue() -> UIColor {
        return UIColor(named: "Blue-Status")!
    }
    
    static func statusLightOrange() -> UIColor {
        return UIColor(named: "LightOrange-Status")!
    }
    
    static func statusGreen() -> UIColor {
        return UIColor(named: "Green-Status")!
    }
    
    static func statusLightRed() -> UIColor {
        return UIColor(named: "FebysLightRedColor")!
    }
    
    static func statusRed() -> UIColor {
        return UIColor(named: "Red-Status")!
    }
    
    static func statusLightGreen() -> UIColor {
        return UIColor(named: "LightGreen-Status")!
    }
    
    static func statusOrange() -> UIColor {
        return UIColor(named: "Orange-Status")!
    }
    
    //MARK: Order Status Colors
    static func statusPending() -> UIColor {
        return UIColor(named: "StatusLightYellow")!
    }
    
    static func statusProcessing() -> UIColor {
        return UIColor(named: "StatusLightBlue")!
    }
    
    static func statusShipped() -> UIColor {
        return UIColor(named: "StatusMildYellow")!
    }
    
    static func statusReceived() -> UIColor {
        return UIColor(named: "StatusLightGreen")!
    }
    
    static func statusCanceled() -> UIColor {
        return UIColor(named: "StatusLightGray")!
    }
    
    static func statusRejected() -> UIColor {
        return UIColor(named: "StatusLightRed")!
    }
    
    static func statusDelivered() -> UIColor {
        return UIColor(named: "StatusMildGreen")!
    }
    
    static func statusCanceledByVendor() -> UIColor {
        return UIColor(named: "StatusLightOrange")!
    }
    
    static func statusReturn() -> UIColor {
        return UIColor(named: "StatusLightPurple")!
    }
    
    static func statusClaimed() -> UIColor {
        return UIColor(named: "StatusMildGreen")!
    }
    
    static func statusRevarsal() -> UIColor {
        return UIColor(named: "StatusLightOrange")!
    }
    
    static func greenTimeline() -> UIColor {
        return UIColor(named: "Green-Timeline")!
    }
    
    static func redTimeline() -> UIColor {
        return UIColor(named: "Red-Timeline")!
    }
    
    
   

    static func getOrderStatusColor(status: OrderStatus?) -> UIColor {
        switch status {
        case .PENDING:
            return .statusPending()
        case .ACCEPTED:
            return .statusProcessing()
        case .CANCELLED_BY_VENDOR:
            return .statusCanceledByVendor()
        case .SHIPPED:
            return .statusShipped()
        case .CANCELED:
            return .statusCanceled()
        case .REJECTED:
            return .statusRejected()
        case .RETURNED:
            return .statusReturn()
        case .DELIVERED:
            return .statusDelivered()
        default :
            return .statusPending()
        }
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
