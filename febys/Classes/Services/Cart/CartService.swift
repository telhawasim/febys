//
//  CartService.swift
//  febys
//
//  Created by Ab Saqib on 02/08/2021.
//
import Foundation

class CartService {
    static let shared = CartService()
    
    private init() { }
    
    func getCart(params info: [String: String] = [:], onComplete: @escaping ((Result<CartResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.CartRoutes.cart.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func updateCart(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<CartResponse, FebysError>)->Void)) {

        let urlString = URLHelper.shared.getURLString(with: URI.CartRoutes.cart.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func downloadCartPDF(body info: [String: Any], onComplete: @escaping ((Result<Data, FebysError>)->Void)) {

        let urlString = URLHelper.shared.getURLString(with: URI.CartRoutes.downloadPdf.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            if let data = data {
                onComplete(.success(data))
            }
            else {
                if let error = error {
                    onComplete(.failure(FebysError.error(error.localizedDescription)))
                }
            }
           
        }
    }
}
