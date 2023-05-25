//
//  KeyclockService.swift
//  febys
//
//  Created by Faisal Shahzad on 21/02/2022.
//

import Foundation
class KeyclockService {
    static let shared = KeyclockService()
    private init() { }
    
    func refreshAccessToken(body info: [String:Any],onComplete: @escaping ((Result<User, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getAuthURLString(with: URI.KeyclockRoutes.refresh.rawValue)
        NetworkManager.shared.sendURLEncodedRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
