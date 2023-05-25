//
//  AccountService.swift
//  febys
//
//  Created by Faisal Shahzad on 08/09/2021.
//

import UIKit

class AccountService {
    static let shared = AccountService()
    
    private init() { }
    
    func getAccountData() -> [Account] {
        var data: [Account]
        let orders : [Setting] = [
            Setting(title: Constants.myOrders),
            Setting(title: Constants.orderReceived),
            Setting(title: Constants.myReview),
            Setting(title: Constants.cancelOrders),
            Setting(title: Constants.returnOrders),
            Setting(title: Constants.wishlist)
        ]
        
        let isUserLoggedIn = (User.fetch() != nil) ? true : false
        let img = UIImage(named: "mapimage")
        let location : [Setting] = [
            Setting(title: Constants.userCountry, image: img, showWithoutLogin: true)
        ]
        
        let settings : [Setting] = [
            Setting(isToggle: true, title: Constants.notifications, showWithoutLogin: true),
            Setting(title: Constants.accountSettings),
            Setting(title: Constants.vouchers),
            Setting(title: Constants.shippingAddress)
        ]
        
        let support : [Setting] = [
            Setting(title: Constants.aboutFebys, showWithoutLogin: true),
            Setting(title: Constants.helpCenter, showWithoutLogin: true),
            Setting(title: Constants.privacyPolicy, showWithoutLogin: true),
            Setting(title: Constants.termsAndConditions, showWithoutLogin: true)
        ]
        
        data = [
            Account(title: Constants.ordersSection,
                    type: .orders(filterData(isUserLoggedIn, data: orders))),
            Account(title: Constants.myLocationSection,
                    type: .location(filterData(isUserLoggedIn, data: location))),
            Account(title: Constants.settingsSection,
                    type: .settings(filterData(isUserLoggedIn, data: settings))),
            Account(title: Constants.supportSection,
                    type: .support(filterData(isUserLoggedIn, data: support)))
        ]
                
        return data
    }
    
    func filterData(_ isLoggedIn: Bool, data: [Setting]) -> [Setting] {
        var filteredData = [Setting]()
        if !isLoggedIn {
            _ = data.compactMap { setting in
                if setting.showWithoutLogin {
                    filteredData.append(setting)
                }
            }
            return filteredData
        } else {
            return data
        }
    }
}
