//
//  CelebrityService.swift
//  febys
//
//  Created by Faisal Shahzad on 22/09/2021.
//

import Foundation

class FollowService{
    static let shared = FollowService()
    private init() { }
    
    func fetchAllFollowingIds(params info: [String: Any] = [:], onComplete: @escaping ((Result<Following, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.FollowRoute.followingIds.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func addToFollowList(id: String, body info: [String: String] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<FollowResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.FollowRoute.followCelebrity.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func removeFromFollowList(id: String, body info: [String: String] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<FollowResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.FollowRoute.unfollowCelebrity.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
