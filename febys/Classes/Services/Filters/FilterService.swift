//
//  FilterService.swift
//  febys
//
//  Created by Faisal Shahzad on 30/12/2021.
//

import Foundation

class FilterService {
    static let shared = FilterService()
    private init() { }
    
    func fetchCategoryFiltersBy(id: Int, params info: [String: Any]=[:], onComplete: @escaping ((Result<FiltersResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.Filters.categoryFilters.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(id)")

        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchTodayDealsFilters(params info: [String: Any]=[:], onComplete: @escaping ((Result<FiltersResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Filters.todayDealsFilters.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchUnder100Filters(params info: [String: Any]=[:], onComplete: @escaping ((Result<FiltersResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Filters.under100Filters.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchSearchProductFilters(params info: [String: Any]=[:], onComplete: @escaping ((Result<FiltersResponse, FebysError>)->Void)) {
        let urlString = URLHelper.shared.getURLString(with: URI.Filters.searchProductFilters.rawValue)
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func fetchVendorProductFiltersBy(id: String, params info: [String: Any]=[:], onComplete: @escaping ((Result<FiltersResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.Filters.vendorProductFilters.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.VENDOR_ID, with: "\(id)")
        
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
