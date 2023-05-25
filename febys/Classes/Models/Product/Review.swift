import Foundation

class Review : Codable {
	var comment : String?
	var id : String?

	enum CodingKeys: String, CodingKey {
		case comment = "comment"
		case id = "_id"
	}

    init() {}
    
	required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		comment = try values.decodeIfPresent(String.self, forKey: .comment)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}

}
