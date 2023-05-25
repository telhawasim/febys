import Foundation

struct WishListResponse : Codable {
	let id : String?
	let consumerId : Int?
	let variantSkuIds : [String]?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {

		case id = "_id"
		case consumerId = "consumer_id"
		case variantSkuIds = "variant_sku_ids"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
		variantSkuIds = try values.decodeIfPresent([String].self, forKey: .variantSkuIds)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
