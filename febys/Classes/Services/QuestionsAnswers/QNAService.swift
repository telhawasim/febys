//
//  QNAService.swift
//  febys
//
//  Created by Faisal Shahzad on 09/11/2021.
//

import Foundation

class QNAService {
    
    static let shared = QNAService()
    private init() {}
    
    func askQuestion(productId: String, body info: [String:String], params: [String: Any] = [:], onComplete: @escaping ((Result<QuestionResponse, FebysError>)->Void)) {
        var urlString = URLHelper.shared.getURLString(with: URI.Question.ask.rawValue)
        
        urlString = urlString.replacingOccurrences(of: Constants.PRODUCT_ID, with: "\(productId)")
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
}
