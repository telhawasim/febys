import Foundation

struct Template : Codable {
	let section : String?
	let images : [Images]?
	let id : String?

	enum CodingKeys: String, CodingKey {
		case section = "section"
		case images = "images"
		case id = "_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		section = try values.decodeIfPresent(String.self, forKey: .section)
		images = try values.decodeIfPresent([Images].self, forKey: .images)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}

}
