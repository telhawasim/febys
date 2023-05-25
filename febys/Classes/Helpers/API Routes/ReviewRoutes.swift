//
//  ReviewRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 08/12/2021.
//

import Foundation

extension URI{
    enum Reviews: String {
        case addVendorReview = "rating-review/add/vendor"
        case addReviewAndRating = "rating-review/save/ORDER_ID"
        case upVote = "rating-review/REVIEW_ID/product/up-vote"
        case downVote = "rating-review/REVIEW_ID/product/down-vote"
    }
}
