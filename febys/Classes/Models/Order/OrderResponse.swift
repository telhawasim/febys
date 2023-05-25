import Foundation

struct OrderResponse : Codable {
	var order : Order?
    let listing : OrderListing?


	enum CodingKeys: String, CodingKey {
		case order = "order"
        case listing = "listing"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		order = try values.decodeIfPresent(Order.self, forKey: .order)
        listing = try values.decodeIfPresent(OrderListing.self, forKey: .listing)

	}

}
