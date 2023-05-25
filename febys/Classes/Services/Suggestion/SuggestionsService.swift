//
//  SuggestionsService.swift
//  febys
//
//  Created by Faisal Shahzad on 26/07/2022.
//

import Foundation

class SuggestionsService {
    static let shared = SuggestionsService()
    private init() {}
   
    func getProductSuggestions(params: [String: Any] = [:], body info: [String: Any], onComplete: @escaping ((Result<SuggestionsResponse, FebysError>)->Void)){
        let urlstring = URLHelper.shared.getSearchURLString()
        
        NetworkManager.shared.sendRequest(method: .POST, urlstring, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
