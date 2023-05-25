import Foundation

struct NavigationMenu : Codable {
	let id : String?
	let name : String?
	let template : String?

	enum CodingKeys: String, CodingKey {

		case id = "_id"
		case name = "name"
		case template = "template"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		template = try values.decodeIfPresent(String.self, forKey: .template)
	}

}
