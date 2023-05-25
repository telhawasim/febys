import Foundation

struct Social: Codable {
	let name : String?
	let url : String?
	let id : String?

	enum CodingKeys: String, CodingKey {

		case name = "name"
		case url = "url"
		case id = "_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}
}
