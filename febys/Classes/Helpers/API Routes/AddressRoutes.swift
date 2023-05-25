//
//  AddressRoutes.swift
//  febys
//
//  Created by Faisal Shahzad on 29/10/2021.
//

import Foundation

extension URI{
    enum Address: String {
        case saveAddress = "consumers/save/shipping-detail"
        case getAddress = "consumers/shipping-details/list"
        case getAddressById = "consumers/shipping-detail/ID"
        case deleteAddressById = "consumers/delete/shipping-detail/ID"
    }
}
