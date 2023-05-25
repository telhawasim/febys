import Foundation

struct RevertDetails : Codable {
	let reason : String?
	let comments : String?

	enum CodingKeys: String, CodingKey {
		case reason = "reason"
		case comments = "comments"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		reason = try values.decodeIfPresent(String.self, forKey: .reason)
		comments = try values.decodeIfPresent(String.self, forKey: .comments)
	}

}
