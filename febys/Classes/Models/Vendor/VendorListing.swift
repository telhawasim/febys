//
//  VendorsResponse.swift
//  febys
//
//  Created by Abdul Kareem on 14/09/2021.
//

import Foundation

struct VendorListing: Codable{
    let key : String?
    var vendors : [Vendor]?
    var celebs : [Vendor]?
    var stores : [Vendor]?
    let pagination_info : PaginationInfo?
    let total_rows : Int?
    
}
