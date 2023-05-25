
import Foundation
struct SignUpResponse : Codable {
	let message : String?
	let user : User?

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case user = "user"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		user = try values.decodeIfPresent(User.self, forKey: .user)
	}
}
