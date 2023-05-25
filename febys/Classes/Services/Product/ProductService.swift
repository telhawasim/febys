//
//  ProductService.swift
//  febys
//
//  Created by Waseem Nasir on 28/06/2021.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    
    private init() { }
    
    func allProducts(body info: [String: Any], params: [String:Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.allProducts.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func productDetail(id: String, params info: [String: String] = [:], onComplete: @escaping ((Result<ProductDetailResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.product.rawValue) + "/\(id)"
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func todayDeals(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.todayDeals.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func trendingProducts(params info: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.trendingProductsByUnits.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func under100(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.under100.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func editorsPick(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.allProducts.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func similarProducts(id: String, body info: [String:Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.similarProducts.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")

        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func recommendedProducts(body info: [String:Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.recommended.rawValue)

        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params, onComplete: { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        })
    }
    
    func specialStoreProducts(body info: [String:Any], params: [String:Any] , onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.spacial.rawValue)

        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params, onComplete: { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        })
    }
    
    func storesYouFollowHome(params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {

        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.storesYouFollowHome.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func storesYouFollow(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.ProductRoutes.storesYouFollow.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    
    
}
