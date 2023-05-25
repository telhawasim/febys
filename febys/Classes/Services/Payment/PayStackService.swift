//
//  PayStackService.swift
//  febys
//
//  Created by Faisal Shahzad on 20/01/2022.
//

import Foundation

class PayStackService {
    static let shared = PayStackService()
    
    func requestPayStack(body info: [String:Any] ,onComplete: @escaping ((Result<PayStackResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.paystackRequest.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func getPayStackStatus(requestId: String, onComplete: @escaping ((Result<TransactionResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.Payment.paystackStatus.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.PAYSTACK_TRANSACTION_ID, with: "\(requestId)")
        
        NetworkManager.shared.sendGetRequest(urlString) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
