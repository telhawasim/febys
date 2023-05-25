//
//  ProductRoutes.swift
//  febys
//
//  Created by Waseem Nasir on 28/06/2021.
//

import Foundation

extension URI{
    enum ProductRoutes: String {
        case trendingProductsByUnits = "top-performers/products/units"
        case trendingProductsBySales = "top-performers/products/sale"
        case todayDeals = "consumers/products/today-deals"
        case product = "products"
        case allProducts = "/consumers/products"
        case similarProducts = "consumers/products/ID/similar"
        case under100 = "consumers/products/under100"
        case storesYouFollowHome = "consumers/products/stores-you/follow/homepage"
        case storesYouFollow = "consumers/products/stores-you/follow/listing"
        case recommended = "consumers/products/recommended"
        case spacial = "consumers/products/spacial/type"
    }
}
