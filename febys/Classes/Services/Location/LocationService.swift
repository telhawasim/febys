//
//  LocationService.swift
//  febys
//
//  Created by Faisal Shahzad on 16/11/2021.
//

import Foundation

class LocationService {
    static let shared = LocationService()
    private init() { }
    
    func fetchCountries(params info: [String:String]=[:], onComplete: @escaping ((Result<LocationResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Location.countries.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchStates(body info: [String:String], onComplete: @escaping ((Result<LocationResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Location.states.rawValue)
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchCities(body info: [String:String], params: [String: Any] = [:], onComplete: @escaping ((Result<LocationResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Location.cities.rawValue)
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
