import Foundation

struct Service : Codable {
	let id : Int?
	let name : String?
	let url : String?
	let logo : String?

	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case url = "url"
		case logo = "logo"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		logo = try values.decodeIfPresent(String.self, forKey: .logo)
	}

}
