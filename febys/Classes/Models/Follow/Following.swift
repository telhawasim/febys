import Foundation

struct Following : Codable {
	let consumerId : Int?
	let followings : [String]?
	let id : String?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {

		case consumerId = "consumer_id"
		case followings = "followings"
		case id = "_id"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
		followings = try values.decodeIfPresent([String].self, forKey: .followings)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
