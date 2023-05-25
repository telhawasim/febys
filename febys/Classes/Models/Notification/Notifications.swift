import Foundation
struct Notifications : Codable {
	let id : String?
	let userId : String?
	let topic : String?
	let title : String?
	let body : String?
	let data : NotificationData?
    var read : Bool?
    let readForBadge : Bool?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {

		case id = "_id"
		case userId = "user_id"
		case topic = "topic"
		case title = "title"
		case body = "body"
        case data = "data"
        case read = "read"
		case readForBadge = "readForBadge"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		userId = try values.decodeIfPresent(String.self, forKey: .userId)
		topic = try values.decodeIfPresent(String.self, forKey: .topic)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		body = try values.decodeIfPresent(String.self, forKey: .body)
        data = try values.decodeIfPresent(NotificationData.self, forKey: .data)
        read = try values.decodeIfPresent(Bool.self, forKey: .read)
        readForBadge = try values.decodeIfPresent(Bool.self, forKey: .readForBadge)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
