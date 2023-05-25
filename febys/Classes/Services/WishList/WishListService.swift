//
//  WishListService.swift
//  febys
//
//  Created by Ab Saqib on 02/08/2021.
//
import Foundation

class WishListService {
    static let shared = WishListService()
    
    private init() { }
    
    func getWishList(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.WishlistRoute.getwishlist.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func addToWishList(body info: [String: Any] = [:], headers: [String: String] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.WishlistRoute.wishlist.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, headers: headers) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func removeFromWishList(body info: [String: Any] = [:], headers: [String: String] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.WishlistRoute.wishlist.rawValue)
        NetworkManager.shared.sendRequest(method: .DELETE, urlString, body: info) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }    
}
