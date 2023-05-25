//
//  CategoryTemplate.swift
//  febys
//
//  Created by Faisal Shahzad on 31/12/2021.
//

import Foundation

struct CategoryTemplate: Codable {
    let logo : String?
    let logoType : String?
    let logoNo : Int?
    let extraInfo : ExtraInfo?

    enum CodingKeys: String, CodingKey {
        case logo = "logo"
        case logoType = "logo_type"
        case logoNo = "logo_no"
        case extraInfo = "extra_info"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        logoType = try values.decodeIfPresent(String.self, forKey: .logoType)
        logoNo = try values.decodeIfPresent(Int.self, forKey: .logoNo)
        extraInfo = try values.decodeIfPresent(ExtraInfo.self, forKey: .extraInfo)
    }

}

struct ExtraInfo : Codable {
    let description : String?
}



