//
//  ReviewVotingService.swift
//  febys
//
//  Created by Faisal Shahzad on 08/12/2021.
//

import Foundation

class ReviewVotingService {
    static let shared = ReviewVotingService()
    
    private init() { }
    
    func upVote(reviewId: String, method type: HTTPMethod, body info: [String:String]=[:], headers: [String: String] = [:], onComplete: @escaping ((Result<Product, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Reviews.upVote.rawValue)
        
        urlString = urlString.replacingOccurrences(of: Constants.REVIEW_ID, with: "\(reviewId)")

        NetworkManager.shared.sendRequest(method: type, urlString, body: info, headers: headers) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func downVote(reviewId: String, method type: HTTPMethod, body info: [String:String]=[:], headers: [String: String] = [:], onComplete: @escaping ((Result<Product, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Reviews.downVote.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.REVIEW_ID, with: "\(reviewId)")

        NetworkManager.shared.sendRequest(method: type, urlString, body: info, headers: headers) { (data, response, error, request) in
            
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
