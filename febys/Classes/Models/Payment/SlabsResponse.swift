//
//  TransactionFeeResponse.swift
//  febys
//
//  Created by Faisal Shahzad on 01/08/2022.
//

import Foundation

struct SlabsResponse : Codable {
    let programs : [SlabData]?
}

struct SlabData : Codable {
    let gateway : String?
    let slab : Slab?
}

struct Slab : Codable {
    let _id : String?
    let currency : String?
    let from : Double?
    let to : Double?
    let type : String?
    let percentage : Double?
    let fixed : Double?
    let value : Double?
}
