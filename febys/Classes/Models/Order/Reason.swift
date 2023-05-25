
import Foundation

struct Reason : Codable {
	let id : Int?
	let name : String?
	let value : String?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case value = "value"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		value = try values.decodeIfPresent(String.self, forKey: .value)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
