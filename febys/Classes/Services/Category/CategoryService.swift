//
//  CategoryService.swift
//  febys
//
//  Created by Waseem Nasir on 28/06/2021.
//

import Foundation

class CategoryService {
    static let shared = CategoryService()
    
    private init() { }
    
    func uniqueCategory(params info: [String: String] = [:], onComplete: @escaping ((Result<[UniqueCategory], FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getConfigURLString(with: URI.Category.uniqueCategory.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func featuredCategories(params info: [String: String] = [:], onComplete: @escaping ((Result<[FeaturedCategoryResponse], FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Category.featuredCategories.rawValue)
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func allCategories(body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<CategoryResponse, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Category.allCategories.rawValue)
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in

            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func productListWithCategory(categoryId: Int, body info: [String: Any] = [:], params: [String: Any] = [:], onComplete: @escaping ((Result<ProductResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Category.categoryProducts.rawValue)
        urlString = urlString.replacingOccurrences(of: "ID", with: "\(categoryId)")
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
