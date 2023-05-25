
import Foundation

struct Features : Codable {
	let _id : String?
	let title : String?

	enum CodingKeys: String, CodingKey {

		case _id = "_id"
		case title = "title"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		title = try values.decodeIfPresent(String.self, forKey: .title)
	}

}
