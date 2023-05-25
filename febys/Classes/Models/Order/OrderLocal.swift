//
//  Order.swift
//  febys
//
//  Created by Faisal Shahzad on 03/10/2021.
//

import Foundation

struct OrderLocal : Codable {
    let id : String?
    let isCancelable: Bool?
    let date : String?
    let status : String?
    let tacking_code : String?
    let delivery_service : String?
    let vendors : [Vendor]?
}
