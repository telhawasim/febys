
import Foundation

struct Package : Codable {
    var isSubscribed = false
	let id : String?
	let title : String?
	let icon : String?
	let description : String?
	let features : [Features]?
	let subscriptionDays : Int?
	let price : Price?
    let updatedAt : String?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case title = "title"
		case icon = "icon"
		case description = "description"
		case features = "features"
		case subscriptionDays = "subscriptionDays"
		case price = "price"
        case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		features = try values.decodeIfPresent([Features].self, forKey: .features)
		subscriptionDays = try values.decodeIfPresent(Int.self, forKey: .subscriptionDays)
		price = try values.decodeIfPresent(Price.self, forKey: .price)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
