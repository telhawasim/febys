//
//  PriceService.swift
//  febys
//
//  Created by Faisal Shahzad on 18/01/2022.
//

import Foundation
class PriceService {
    static let shared = PriceService()
    private init() { }
    
//    func getConvertedPrice(body info: [String:Any],onComplete: @escaping ((Result<ConversionRate, FebysError>)->Void)) {
//        let urlString = URLHelper.shared.getURLString(with: URI.Payment.convertPrice.rawValue)
//        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
//            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
//            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
//        }
//    }
    
    func getConversionRate(body info: [String:Any],onComplete: @escaping ((Result<ConversionRate, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Payment.conversionRate.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
