//
//  FilterRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 30/12/2021.
//

import Foundation

extension URI{
    enum Filters: String {
        case categoryFilters = "categories/ID/filters"
        case todayDealsFilters = "consumers/today/deals/filters"
        case under100Filters = "consumers/under/100/filters"
        case searchProductFilters = "consumers/products/search/filters"
        case vendorProductFilters = "consumers/vendor/VENDOR_ID/filters"
    }
}
