//
//  NotificationCount.swift
//  febys
//
//  Created by Faisal Shahzad on 15/03/2022.
//

import Foundation
struct NotificationCount : Codable {
    let unread : Int?
    let badge : Int?
    
    enum CodingKeys: String, CodingKey {
        case unread = "un_read"
        case badge = "badge"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        unread = try values.decodeIfPresent(Int.self, forKey: .unread)
        badge = try values.decodeIfPresent(Int.self, forKey: .badge)
    }
    
}
