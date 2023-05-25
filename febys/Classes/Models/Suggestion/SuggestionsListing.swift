
import Foundation

struct SuggestionsListing : Codable {
    var search : [Suggesstion]?
	let paginationInfo : PaginationInfo?
	let totalRows : Int?

	enum CodingKeys: String, CodingKey {
		case search = "search"
		case paginationInfo = "pagination_info"
		case totalRows = "total_rows"
	}
}
