//
//  RatingAndReviewResponse.swift
//  febys
//
//  Created by Faisal Shahzad on 23/12/2021.
//

import Foundation

struct RatingAndReviewResponse: Codable {
    let productsRatings: [RatingsAndReviews]?
    let vendorRating: RatingsAndReviews?

    enum CodingKeys: String, CodingKey {
        case productsRatings = "products_ratings"
        case vendorRating = "vendor_rating"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productsRatings = try values.decodeIfPresent([RatingsAndReviews].self, forKey: .productsRatings)
        vendorRating = try values.decodeIfPresent(RatingsAndReviews.self, forKey: .vendorRating)
    }

}
