//
//  PaymentRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 31/10/2021.
//

import Foundation
import SwiftUI

extension URI {
    enum Payment: String {
        case walletDetail = "payments/wallet/detail"
        case paypalPayment = "payments/transaction/paypal"
        case walletPayment = "payments/transaction/wallet"
        case conversionRate = "payments/currency-conversion/rate"
        case convertPrice = "payments/currency-converted/amount"
        case paystackRequest = "payments/transaction/paystack"
        case paystackStatus = "payments/transaction/paystack/PAYSTACK_TRANSACTION_ID"
        case transactionHistory = "payments/transactions/listing"
        case transactionFeeSlabs = "payment-programs/fee-slabs"
        case braintreeToken = "payments/transaction/braintree/fetch-client-token"
        case braintreePayment = "payments/transaction/braintree"
        
    }
}
