import Foundation

struct Score : Codable {
    let id : String?
	let score : Double?
	let count : Int?

	enum CodingKeys: String, CodingKey {
        case id = "_id"
		case score = "score"
		case count = "count"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
		score = try values.decodeIfPresent(Double.self, forKey: .score)
		count = try values.decodeIfPresent(Int.self, forKey: .count)
	}

}
