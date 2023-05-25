
import Foundation

struct TopPerformers : Codable {
	let unitsSold : Int?
	let skuId : String?
	let sales : Sales?
	let product : Product?

	enum CodingKeys: String, CodingKey {

		case unitsSold = "units_sold"
		case skuId = "sku_id"
		case sales = "sales"
		case product = "product"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		unitsSold = try values.decodeIfPresent(Int.self, forKey: .unitsSold)
		skuId = try values.decodeIfPresent(String.self, forKey: .skuId)
		sales = try values.decodeIfPresent(Sales.self, forKey: .sales)
		product = try values.decodeIfPresent(Product.self, forKey: .product)
	}

}
