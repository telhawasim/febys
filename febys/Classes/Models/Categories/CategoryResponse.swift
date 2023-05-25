//
//  CategoryResponse.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import Foundation

struct CategoryResponse : Codable {
	var listing : Listing?
}

struct ProductResponse : Codable {
    var listing : ProductListing?
}

struct VendorResponse : Codable {
    var listing : VendorListing?
}

struct CelebsResponse : Codable {
    var celebs : [Vendor]?
}

struct FollowResponse : Codable {
    let following : Following?
}

struct QuestionResponse : Codable {
    let questionAnswers : QuestionAnswers?
}

struct VoucherResponse : Codable {
    let vouchers : [Vouchers]?
    let voucher : Voucher?
}


//protocol ProductListDataSource {
//    func fetchData()
//}


