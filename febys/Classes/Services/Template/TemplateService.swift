//
//  TemplateService.swift
//  febys
//
//  Created by Faisal Shahzad on 16/12/2021.
//

import Foundation

class TemplateService {
    static let shared = TemplateService()
    private init() { }
    
    func fetchStoreTemplateBy(id: String, params info: [String: Any]=[:], onComplete: @escaping ((Result<StoreTemplate, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getConfigURLString(with: URI.Template.storeTemplate.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.TEMPLATE_ID, with: "\(id)")
 
        NetworkManager.shared.sendGetRequest(urlString, params: info) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    
}
