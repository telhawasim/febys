//
//  AddressService.swift
//  febys
//
//  Created by Faisal Shahzad on 29/09/2021.
//

import Foundation

class AddressService {
    
    static let shared = AddressService()
    private init() { }
    
    func fetchShippingAddress(body info: [String: String] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<AddressResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Address.getAddress.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func saveShippingAddress(body info: [String: Any], params: [String: Any] = [:], onComplete: @escaping ((Result<ShippingDetails, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Address.saveAddress.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchShippingAddressBy(id: String, params info: [String: String] = [:], onComplete: @escaping ((Result<ShippingDetails, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Address.getAddressById.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")

        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func deleteShippingAddressBy(id: String, body info: [String: String] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<EmptyResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Address.deleteAddressById.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")

        NetworkManager.shared.sendRequest(method: .DELETE, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
