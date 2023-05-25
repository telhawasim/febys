
import Foundation
struct TransactionListing : Codable {
    var transactions : [Transaction]?
	let paginationInfo : PaginationInfo?
	let totalRows : Int?

	enum CodingKeys: String, CodingKey {

		case transactions = "transactions"
		case paginationInfo = "pagination_info"
		case totalRows = "total_rows"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		transactions = try values.decodeIfPresent([Transaction].self, forKey: .transactions)
		paginationInfo = try values.decodeIfPresent(PaginationInfo.self, forKey: .paginationInfo)
		totalRows = try values.decodeIfPresent(Int.self, forKey: .totalRows)
	}

}
