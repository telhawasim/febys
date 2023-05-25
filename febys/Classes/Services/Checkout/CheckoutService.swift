//
//  CheckoutService.swift
//  febys
//
//  Created by Faisal Shahzad on 15/09/2021.
//

import UIKit

class CheckoutService {

    static let shared = CheckoutService()
    
    private init() { }

    func getCheckoutSections() -> [CheckoutInfo]{
        return [
            CheckoutInfo(isPayment: false, title: "Shipping Address", description: "Virtual Incubator, Busy Internet, Accra-north 23321, Ghana"),
            CheckoutInfo(isPayment: true, title: "Payment", description: "RavePay")
        ]
    }
}
