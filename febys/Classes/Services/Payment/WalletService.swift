//
//  WalletService.swift
//  febys
//
//  Created by Faisal Shahzad on 17/01/2022.
//

import Foundation

class WalletService{
    static let shared = WalletService()
    
    func fetchUserWallet(onComplete: @escaping ((Result<WalletResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.walletDetail.rawValue)
        NetworkManager.shared.sendGetRequest(urlString) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func processWalletPayment(body info: [String: Any], params: [String: Any] = [:], onComplete: @escaping ((Result<TransactionResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.walletPayment.rawValue)

        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}



