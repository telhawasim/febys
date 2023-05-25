//
//  UniqueCategory.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import Foundation
struct Listing : Codable {
	let total_rows : Int?
	var categories : [Categories]?
	let pagination_information : PaginationInfo?
    
}

struct ProductListing : Codable {
    let totalRows : Int?
    var products : [Product]?
    let topPerformers : [TopPerformers]?
    let paginationInfo : PaginationInfo?
    
    enum CodingKeys: String, CodingKey {
        case totalRows = "total_rows"
        case products = "products"
        case topPerformers = "top_performers"
        case paginationInfo = "pagination_info"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalRows = try values.decodeIfPresent(Int.self, forKey: .totalRows)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
        topPerformers = try values.decodeIfPresent([TopPerformers].self, forKey: .topPerformers)
        paginationInfo = try values.decodeIfPresent(PaginationInfo.self, forKey: .paginationInfo)
    }
}

