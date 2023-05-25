//
//  BraintreeService.swift
//  febys
//
//  Created by Faisal Shahzad on 01/08/2022.
//

import Foundation

class BraintreeService{
    
    // MARK: - Singleton
    static let shared = BraintreeService()
    private init() {}
    
    // MARK: - Attributes
    static var clientId = "AVxMDtg2UkfX0IFBK86r_l_EcCeloAcMmOQf7vbOuPQsr10I5QJBf-u4YVn504puI-GyLQ0ZcKRYBG2T"
    
    static let returnUrl: String = "com.hexagram.febys://paypalpay"
    static let supportedCurrencies = ["AUD", "USD", "EUR", "CAD", "MXN", "GBP"]
    
    
    func postPaymentOnBraintree(body info: [String: Any] = [:], onComplete: @escaping ((Result<TransactionResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.braintreePayment.rawValue)
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func getBraintreeToken(body info: [String: Any] = [:], onComplete: @escaping ((Result<BTTokenResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.braintreeToken.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString) {
            (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }

}


