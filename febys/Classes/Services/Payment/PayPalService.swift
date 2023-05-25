//
//  PayPalService.swift
//
//  Created by Faisal Shahzad on 1/15/22.
//

import Foundation
import PayPalCheckout

class PayPalService{
    
    // MARK: - Singleton
    static let shared = PayPalService()
    private init() {}
    
    // MARK: - Attributes
    static var clientId = "AVxMDtg2UkfX0IFBK86r_l_EcCeloAcMmOQf7vbOuPQsr10I5QJBf-u4YVn504puI-GyLQ0ZcKRYBG2T"
    
    static let returnUrl: String = "com.hexagram.febys://paypalpay"
    static let supportedCurrencies = ["AUD", "USD", "EUR", "CAD", "MXN", "GBP"]
    
    func processOrderActions(with approval: Approval, onComplete: @escaping (Result<OrderActionData, Error>) -> Void) {
        switch approval.data.intent.stringValue.uppercased() {
        case "AUTHORIZE":
            approval.actions.authorize { success, error in
                if let success = success {
                    onComplete(.success(success.data))
                } else if let error = error {
                    onComplete(.failure(error))
                } else {
                    print("Unhandled State: No Error and No Success Response")
                }
            }
            
        case "CAPTURE", "SALE":
            approval.actions.capture { success, error in
                if let success = success {
                    onComplete(.success(success.data))
                } else if let error = error {
                    onComplete(.failure(error))
                } else {
                    print("Unhandled State: No Error and No Success Response")
                }
            }
            
        default:
            break
        }
    }
    
    func proceedPaypalPayment(body info: [String: Any], onComplete: @escaping ((Result<TransactionResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.paypalPayment.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}


