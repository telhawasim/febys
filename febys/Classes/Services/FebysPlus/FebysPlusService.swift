//
//  FebysPlusService.swift
//  febys
//
//  Created by Nouman Akram on 01/02/2022.
//

import Foundation

class FebysPlusService {
    static let shared = FebysPlusService()
    private init() { }
    
    func getFebysPlusData(onComplete: @escaping ((Result<PackageResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.FebysPlusRoutes.packages.rawValue)
        NetworkManager.shared.sendGetRequest(urlString) {
            (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func subscribePackageBy(id: String, body info: [String:Any], onComplete: @escaping ((Result<PackageResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.FebysPlusRoutes.subscribe.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.PACKAGE_ID, with: "\(id)")
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) {
            (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
