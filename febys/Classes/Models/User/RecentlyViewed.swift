import Foundation

struct RecentlyViewed : Codable {
	let consumerId : Int?
	let variantSkuIds : [String]?
	let id : String?

	enum CodingKeys: String, CodingKey {

		case consumerId = "consumer_id"
		case variantSkuIds = "variant_sku_ids"
		case id = "_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
		variantSkuIds = try values.decodeIfPresent([String].self, forKey: .variantSkuIds)
		id = try values.decodeIfPresent(String.self, forKey: .id)
	}

}
