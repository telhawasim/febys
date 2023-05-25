
import Foundation

struct Errors : Codable {
	let field : String?
	let error : String?

	enum CodingKeys: String, CodingKey {

		case field = "field"
		case error = "error"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		field = try values.decodeIfPresent(String.self, forKey: .field)
		error = try values.decodeIfPresent(String.self, forKey: .error)
	}

}
