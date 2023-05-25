//
//  VendorRoute.swift
//  febys
//
//  Created by Abdul Kareem on 13/09/2021.
//

import Foundation

extension URI{
    enum VendorRoute: String {
        case vendorlist = "consumers/stores"
        case vendorRecommendedList = "consumers/stores/recommendations"
        case followedVendorList = "consumers/stores/following"
        case vendorProductList = "consumers/products/vendor/ID"
    }
}
