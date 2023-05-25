import Foundation
struct Subscription : Codable {
	let id : String?
	let consumerId : Int?
	let packageInfo : Package?
	let transactions : [Transaction]?
	let expiry : String?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case consumerId = "consumer_id"
		case packageInfo = "package_info"
		case transactions = "transactions"
		case expiry = "expiry"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
		packageInfo = try values.decodeIfPresent(Package.self, forKey: .packageInfo)
		transactions = try values.decodeIfPresent([Transaction].self, forKey: .transactions)
		expiry = try values.decodeIfPresent(String.self, forKey: .expiry)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
