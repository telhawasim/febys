//
//  PaymentRequest.swift
//  febys
//
//  Created by Faisal Shahzad on 04/08/2022.
//

import Foundation

struct PaymentRequest: Codable {
    var billingCurrency: String?
    var billingAmount: Double?
    var deviceData: String?
    var nonce: String?
    var transactionFee: Double?
    var requestedCurrency: String?
    var requestedAmount: Double?
    var purpose: String?
}
