//
//  UniqueCategory.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import Foundation

struct UniqueCategory : Codable {
    let image : [String]?
    let id : String?
    let name : String?
    let link : String?
    let categoryId : Int?


    enum CodingKeys: String, CodingKey {
        case image = "image"
        case id = "_id"
        case name = "name"
        case link = "link"
        case categoryId = "category_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        image = try values.decodeIfPresent([String].self, forKey: .image)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
    }

}
