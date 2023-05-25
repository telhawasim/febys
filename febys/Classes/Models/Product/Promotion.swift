
import Foundation

struct Promotion : Codable {
	let price : Price?
	let startDate : String?
	let endDate : String?
	let id : String?

	enum CodingKeys: String, CodingKey {
		case price = "price"
		case startDate = "start_date"
		case endDate = "end_date"
		case id = "_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		price = try values.decodeIfPresent(Price.self, forKey: .price)
		startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
		endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}
}


