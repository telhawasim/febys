//
//  ReviewsService.swift
//  febys
//
//  Created by Faisal Shahzad on 15/12/2021.
//

import Foundation

class ReviewsService {
    static let shared = ReviewsService()
    private init() { }
    
    func addProductReview(body info: [String: Any]=[:], params: [String: Any] = [:], onComplete: @escaping ((Result<RatingsAndReviews, FebysError>)->Void)) {
        
        let urlString = URLHelper.shared.getURLString(with: URI.Reviews.addVendorReview.rawValue)
        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
    func addProductRatingAndReview(id orderId: String ,body info: [String: Any]=[:], params: [String: Any] = [:], onComplete: @escaping ((Result<RatingAndReviewResponse, FebysError>)->Void)) {
        
        var urlString = URLHelper.shared.getURLString(with: URI.Reviews.addReviewAndRating.rawValue)
        urlString = urlString.replacingOccurrences(of: Constants.ORDER_ID, with: "\(orderId)")

        
        NetworkManager.shared.sendRequest(method: .POST, urlString, body: info, params: params) { (data, response, error, request) in
            guard APIErrorHandler.shared.handleError(data: data, response: response, error: error, request: request, onComplete: onComplete) else {return}
            ResponseManager.shared.decode(data: data, response: response, error: error, onComplete: onComplete)
        }
    }
    
}
