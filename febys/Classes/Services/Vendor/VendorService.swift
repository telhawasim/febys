//
//  VendorService.swift
//  febys
//
//  Created by Abdul Kareem on 13/09/2021.
//

import Foundation

class VendorService{
    static let shared = VendorService()
    private init() { }
    
    func getVendorListing(isRecommended: Bool, body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<VendorResponse, FebysError>)->Void)) {
        
        let urlRoute = isRecommended
        ? URI.VendorRoute.vendorRecommendedList.rawValue
        : URI.VendorRoute.vendorlist.rawValue
        
        let urlString = URLHelper.shared.getURLString(with: urlRoute)
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)        }
    }
    
    func getFollowedVendorList(params info: [String: String] = [:], onComplete: @escaping ((Result<VendorListing, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.VendorRoute.followedVendorList.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }

    
    func getVendorProductsBy(id: String, body info: [String:Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.VendorRoute.vendorProductList.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
