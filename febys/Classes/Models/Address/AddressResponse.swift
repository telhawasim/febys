import Foundation

class AddressResponse : Codable {
    var shippingDetails : [ShippingDetails]?

	enum CodingKeys: String, CodingKey {
		case shippingDetails = "shipping_details"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		shippingDetails = try values.decodeIfPresent([ShippingDetails].self, forKey: .shippingDetails)
	}

}
