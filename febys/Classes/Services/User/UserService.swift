//
//  UserService.swift
//  febys
//
//  Created by Waseem Nasir on 28/06/2021.
//

import Foundation
import UIKit

class UserService {
    static let shared = UserService()
    
    private init() { }
    
    func fetchUserInfo(params info: [String: String] = [:], onComplete: @escaping ((Result<UserInfo, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.info.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func signIn(body info: [String: String], headers: [String: String] = [:], onComplete: @escaping ((Result<SignUpResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.login.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, headers: headers) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func socialSignIn(params info: [String: String], onComplete: @escaping ((Result<SignUpResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.socialLogin.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func signUp(body info: [String: String], headers: [String: String] = [:], onComplete: @escaping ((Result<SignUpResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.signUp.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, headers: headers) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func forgotPassword(body info: [String: String], headers: [String: String] = [:], onComplete: @escaping ((Result<Bool, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.forgotPassword.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            onComplete(.success(true))
        }
    }
    
    func verifyOTP(body info: [String: String], headers: [String: String] = [:], onComplete: @escaping ((Result<SignUpResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.verifyOTP.rawValue)
        NetworkManager.shared.sendRequest(method: .PATCH, urlString, body: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func profileUpdate(body info: [String:Any], onComplete: @escaping ((Result<SignUpResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.signUp.rawValue)
        NetworkManager.shared.sendRequest(method: .PUT, urlString, body: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func uploadProfileImage(with image: UIImage, parameters info: [String: String] = [:], onComplete: @escaping ((Result<[String], FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.uploadImage.rawValue)
        NetworkManager.shared.requestNativeImageUpload(urlString, parameters: info, image: image) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func deleteUser(body info: [String: Any] = [:], headers: [String: Any] = [:], onComplete: @escaping ((Result<Bool, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Users.signUp.rawValue)
        NetworkManager.shared.sendRequest(method: .DELETE, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            onComplete(.success(true))
        }
    }
}
