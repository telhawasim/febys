//
//  Swoove.swift
//  febys
//
//  Created by Faisal Shahzad on 28/08/2022.
//

import Foundation
struct Swoove : Codable {
    let estimate : Estimate?

    enum CodingKeys: String, CodingKey {
        case estimate = "estimate"
    }
}
