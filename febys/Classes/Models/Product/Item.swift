import Foundation
struct Item : Codable {
    let id : String?
    let skuId : String?
    let qty : Int?
    let price : Price?
    let commission : Price?

	enum CodingKeys: String, CodingKey {
        case id = "_id"
        case skuId = "sku_id"
        case qty = "qty"
        case price = "price"
        case commission = "commission"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
        qty = try values.decodeIfPresent(Int.self, forKey: .qty)
        price = try values.decodeIfPresent(Price.self, forKey: .price)
        commission = try values.decodeIfPresent(Price.self, forKey: .commission)
	}

}
