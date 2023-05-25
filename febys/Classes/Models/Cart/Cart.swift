
import Foundation

struct Cart : Codable {
	let id : String?
	let vendorProducts : [VendorProducts]?

	enum CodingKeys: String, CodingKey {
		case id = "_id"
		case vendorProducts = "vendor_products"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		vendorProducts = try values.decodeIfPresent([VendorProducts].self, forKey: .vendorProducts)
	}
    
}

