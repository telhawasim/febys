//
//  TokenManager.swift
//  febys
//
//  Created by Faisal Shahzad on 17/02/2022.
//

import Foundation
import UIKit
import JWTDecode

class TokenManager: NSObject {
    
    //MARK:- PROPERTIES
    static var shared = TokenManager()
    private var isRequestInProgress = false
    private var pendingRequests = [URLRequest?]()
    
    //MARK:- Api Callings
    func handleTokenExpiry<T:Codable>(with request: URLRequest?, onComplete: @escaping ((Result<T, FebysError>)->Void)) {
        if isRequestInProgress{
            self.pendingRequests.append(request)
            return
        }
        
        self.isRequestInProgress = true
        self.refreshAccessToken(request: request, onComplete: onComplete)
    }
    
    private func refreshAccessToken<T:Codable>(request: URLRequest?, onComplete: @escaping ((Result<T, FebysError>)->Void)) {
        
        guard let user = User.fetch() else {return}
        
        let clientSecret = ConfigurationManager.shared.infoForKey(.clientSecret)
        let bodyParams = [ParameterKeys.client_id: Constants.febys_backend,
                          ParameterKeys.grant_type: Constants.refresh_token,
                          ParameterKeys.refresh_token: user.refresh_token ?? "",
                          ParameterKeys.client_secret: clientSecret ?? ""] as [String : Any]
        
        KeyclockService.shared.refreshAccessToken(body: bodyParams) { response in
            switch response {
            case .success(let tokenResponse):
                var user = User.fetch()
                user?.access_token = tokenResponse.access_token
                user?.refresh_token = tokenResponse.refresh_token
                _ = user?.save()
                
                self.pendingRequests.append(request)
                
                _ = self.pendingRequests.compactMap({ urlRequest in
                    self.sendURLRequest(urlRequest, newToken: tokenResponse.access_token ?? "", onComplete: onComplete)
                })
                
                DispatchQueue.main.async {
                    self.isRequestInProgress = false
                    self.pendingRequests.removeAll()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isRequestInProgress = false
                    self.userSignOut()
                }
            }
        }
    }
    
    private func sendURLRequest<T:Codable>(_ request: URLRequest?, newToken: String, onComplete: @escaping ((Result<T, FebysError>)->Void)) {
        
        guard var request = request else {return}
        
        request.setValue("Bearer \(newToken)", forHTTPHeaderField: Constants.authorization)
        
        NetworkManager.shared.startURLSession(request: request) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
        
    }
    
    func userSignOut() {
        if let userId = UserInfo.fetch()?.consumerInfo?.id {
            FirebaseManager.shared.unSubscribeToTopic(userId)
        }
        DispatchQueue.main.async {
            CartEntity.clearAllFromCoreData()
            User.remove()
            UserInfo.remove()
            ShippingDetails.remove()
            WishlistManager.shared.clearWishList()
            ZendeskManager.shared.resetVisitorIdentity()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
