import Foundation
struct NotificationListing : Codable {
    
    let totalRows : Int?
    var notifications : [Notifications]?
    let paginationInfo : PaginationInfo?
    
	enum CodingKeys: String, CodingKey {

        case totalRows = "total_rows"
        case notifications = "notifications"
        case paginationInfo = "pagination_info"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        totalRows = try values.decodeIfPresent(Int.self, forKey: .totalRows)
        notifications = try values.decodeIfPresent([Notifications].self, forKey: .notifications)
        paginationInfo = try values.decodeIfPresent(PaginationInfo.self, forKey: .paginationInfo)
	}

}
