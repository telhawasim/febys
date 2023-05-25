//
//  CelebrityRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 22/09/2021.
//


import Foundation

extension URI{
    enum CelebrityRoute: String {
        case celebritylist = "consumers/celebs"
        case celebrityRecommendedList = "consumers/celebs/recommendations"
        case followedCelebrityList = "consumers/celebs/following"
        case celebrityDetails = "consumers/vendor-detail/ID"
        case myEndorsementList = "vendors/ID/endorsements"
        case celebrityProductList = "consumers/products/vendor/ID"
    }
}
