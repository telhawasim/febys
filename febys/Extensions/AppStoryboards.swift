//
//  AppStoryboards.swift
//  febys
//
//  Created by Waseem Nasir on 26/06/2021.
//

import UIKit

extension UIStoryboard {
    
    //MARK: Generic Public/Instance Methods
    func loadViewController(withIdentifier identifier: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier:  identifier)
    }
    
    //MARK: Class Methods to load Storyboards
    class func storyBoard(withName name: storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue , bundle: Bundle.main)
    }
    
    class func storyBoard(withTextName name:String) -> UIStoryboard {
        return UIStoryboard(name: name , bundle: Bundle.main)
    }
    
    class func getVC(from: storyboards, _ name: String) -> UIViewController {
        return UIStoryboard(name: from.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: name)
    }
    
}

enum storyboards : String {
    
    //All Storyboards
    case Auth = "Auth",
         Main = "Main",
         Notification = "Notification",
         Account = "Account",
         Menu = "Menu",
         PopUp = "PopUp",
         Product = "Product",
         Orders = "Orders",
         WishList = "WishList",
         ShoppingCart = "ShoppingCart",
         ShippingAddress = "ShippingAddress",
         VendorStore = "VendorStore",
         Payments = "Payments",
         Filters = "Filters",
         FebysPlus = "FebysPlus",
         Wallet = "Wallet"
}
