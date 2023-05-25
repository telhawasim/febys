import Foundation

struct HamburgerMenu : Codable {
	let id : String?
	let name : String?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case id = "_id"
		case name = "name"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
