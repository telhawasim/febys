//
//  TransactionHistory.swift
//  febys
//
//  Created by Nouman Akram on 24/01/2022.
//

import Foundation

class TransactionService {
    static let shared = TransactionService()
    private init() {}
    
    func transactionHistory(params: [String: Any], body info: [String: Any], onComplete: @escaping ((Result<TransactionResponse, FebysError>)->Void)){
        let urlstring = URLHelper.shared.getURLString(with: URI.Payment.transactionHistory.rawValue)
        
        NetworkManager.shared.sendRequest(method: .POST, urlstring, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
