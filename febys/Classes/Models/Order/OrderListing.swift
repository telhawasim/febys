import Foundation

struct OrderListing : Codable {
    var orders : [Order]?
	let paginationInfo : PaginationInfo?
	let totalRows : Int?

	enum CodingKeys: String, CodingKey {

		case orders = "orders"
		case paginationInfo = "pagination_info"
		case totalRows = "total_rows"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		orders = try values.decodeIfPresent([Order].self, forKey: .orders)
        paginationInfo = try values.decodeIfPresent(PaginationInfo.self, forKey: .paginationInfo)
        totalRows = try values.decodeIfPresent(Int.self, forKey: .totalRows)
	}

}
