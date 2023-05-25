//
//  CelebrityService.swift
//  febys
//
//  Created by Faisal Shahzad on 22/09/2021.
//

import Foundation

class CelebrityService{
    static let shared = CelebrityService()
    private init() { }
    
    func getCelebrityListing(isRecommended: Bool, body info: [String: Any] = [:], params: [String:Any] = [:], onComplete: @escaping ((Result<VendorResponse, FebysError>)->Void)) {
        let urlRoute = isRecommended ? URI.CelebrityRoute.celebrityRecommendedList.rawValue : URI.CelebrityRoute.celebritylist.rawValue
        let urlString = URLHelper.shared.getURLString(with: urlRoute)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func getFollowedCelebrityList(params info: [String: String] = [:], onComplete: @escaping ((Result<VendorListing, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.CelebrityRoute.followedCelebrityList.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func getCelebrityDetails(id: String, params info: [String: String] = [:], onComplete: @escaping ((Result<Vendor, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.CelebrityRoute.celebrityDetails.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")

        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func getMyEndorsement(id: String, body info: [String: String] = [:], headers: [String: String] = [:], onComplete: @escaping ((Result<VendorListing, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.CelebrityRoute.myEndorsementList.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    
    func getCelebrityProductListing(id: String, body info: [String:Any], params: [String:Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.CelebrityRoute.celebrityProductList.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}

