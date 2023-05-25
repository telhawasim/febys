//
//  VotingService.swift
//  febys
//
//  Created by Faisal Shahzad on 05/11/2021.
//

import Foundation


class QuestionVotingService {
    static let shared = QuestionVotingService()
    
    private init() { }
    
    func upVote(productId: String, threadId: String, method type: HTTPMethod, body info: [String:String]=[:], params: [String: Any] = [:], onComplete: @escaping ((Result<QuestionResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Voting.upVote.rawValue)
        
        urlString = urlString.replacingOccurrences(of: Constants.PRODUCT_ID, with: "\(productId)")
        urlString = urlString.replacingOccurrences(of: Constants.THREAD_ID, with: "\(threadId)")

        NetworkManager.shared.sendRequest(method: type, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func downVote(productId: String, threadId: String, method type: HTTPMethod, body info: [String:String]=[:], params: [String: Any] = [:], onComplete: @escaping ((Result<QuestionResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Voting.downVote.rawValue)
        
        urlString = urlString.replacingOccurrences(of: Constants.PRODUCT_ID, with: "\(productId)")
        urlString = urlString.replacingOccurrences(of: Constants.THREAD_ID, with: "\(threadId)")

        NetworkManager.shared.sendRequest(method: type, urlString, body: info, params: params) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
