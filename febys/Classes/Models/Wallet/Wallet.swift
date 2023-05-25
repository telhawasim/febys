//
//  Wallet.swift
//  febys
//
//  Created by Faisal Shahzad on 17/01/2022.
//

import Foundation
struct Wallet : Codable {
    let id : String?
    let userId : String?
    let currency : String?
    let availableBalance : Double?
    var convertedCurrency : String?
    var convertedBalance : Double?

    
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId = "user_id"
        case currency = "currency"
        case availableBalance = "available_balance"
        case convertedCurrency = "converted_currency"
        case convertedBalance = "converted_balance"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        availableBalance = try values.decodeIfPresent(Double.self, forKey: .availableBalance)
        convertedCurrency = try values.decodeIfPresent(String.self, forKey: .convertedCurrency)
        convertedBalance = try values.decodeIfPresent(Double.self, forKey: .convertedBalance)
    }

}
