
import Foundation
struct NotificationData : Codable {
	let orderId : String?
	let status : String?
	let type : String?
	let sendedAt : String?
    let message : String?
    let threadId : String?
    let productId : String?
    let consumerName : String?

	enum CodingKeys: String, CodingKey {
		case orderId = "order_id"
		case status = "status"
		case type = "type"
		case sendedAt = "sended_at"
        case message = "message"
        case threadId = "thread_id"
        case productId = "product_id"
        case consumerName = "consumer_name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		sendedAt = try values.decodeIfPresent(String.self, forKey: .sendedAt)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        threadId = try values.decodeIfPresent(String.self, forKey: .threadId)
        productId = try values.decodeIfPresent(String.self, forKey: .productId)
        consumerName = try values.decodeIfPresent(String.self, forKey: .consumerName)
	}

}
