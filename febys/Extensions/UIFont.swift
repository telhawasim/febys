//
//  UIFont.swift
//  febys
//
//  Created by Waseem Nasir on 26/06/2021.
//

import UIKit

/// Enum for all HelveticaNeue fonts available in the app
enum Helvetica: String {
    case semiBoldItalic = "HelveticaNeue-SemiBoldItalic"
    case semiBold = "HelveticaNeue-SemiBold"
    case regular = "HelveticaNeue"
    case mediumItalic = "HelveticaNeue-MediumItalic"
    case medium = "HelveticaNeue-Medium"
    case lightItalic = "HelveticaNeue-LightItalic"
    case light = "HelveticaNeue-Light"
    case italic = "HelveticaNeue-Italic"
    case extraLightItalic = "HelveticaNeue-ExtraLightItalic"
    case extraLight = "HelveticaNeue-ExtraLight"
    case extraBoldItalic = "HelveticaNeue-ExtraBoldItalic"
    case extraBold = "HelveticaNeue-ExtraBold"
    case boldItalic = "HelveticaNeue-BoldItalic"
    case bold = "HelveticaNeue-Bold"
    case blackItalic = "HelveticaNeue-BlackItalic"
    case black = "HelveticaNeue-Black"
}

enum Arial: String {
    case regular = "Arial"
    case bold = "Arial-BoldMT"
}

extension UIFont {
    
    /// Creates and returns HelveticaNeue font with given style
    ///
    /// Trys to create a font with `Helvetica Neue` style given. If font style is not found it create an object with font size
    /// - Parameter font: a value of type `Helvetica Neue` to get HelveticaNeue font of that type
    /// - Parameter size: size of font to be returned
    /// - Returns : UIFont with given font style
    static func helvetica(type font: Helvetica, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size)!
    }
    
    static func arial(type font: Arial, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size)!
    }
}
