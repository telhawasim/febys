import Foundation

struct QuestionAnswers : Codable {
	let id : String?
	let productId : String?
	let threads : [QnAThread]?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {

		case id = "_id"
		case productId = "product_id"
		case threads = "threads"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		productId = try values.decodeIfPresent(String.self, forKey: .productId)
		threads = try values.decodeIfPresent([QnAThread].self, forKey: .threads)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
