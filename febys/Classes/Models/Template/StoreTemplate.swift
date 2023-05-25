//
//  StoreTemplate.swift
//  febys
//
//  Created by Faisal Shahzad on 16/12/2021.
//

import Foundation

struct StoreTemplate : Codable {
    let id : String?
    let active : Bool?
    let name : String?
    let content : String?
    let updatedAt : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "_id"
        case active = "active"
        case name = "name"
        case content = "content"
        case updatedAt = "updatedAt"
        case createdAt = "createdAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }

}
