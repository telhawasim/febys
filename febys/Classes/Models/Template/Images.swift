import Foundation
struct Images : Codable {
	let url : String?
	let href : String?
	let id : String?

	enum CodingKeys: String, CodingKey {

		case url = "url"
		case href = "href"
		case id = "_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		url = try values.decodeIfPresent(String.self, forKey: .url)
		href = try values.decodeIfPresent(String.self, forKey: .href)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}

}
