import Foundation

struct ReturnDetail : Codable {
    let id : String?
    let vendorId : String?
    let orderId : String?
    let consumerId : Int?
    let items : [Item]?
    let totalAmount : Price?
    let totalCommission : Price?
    let returnFeePercentage : Int?
    let reason : String?
    let comments : String?
    let status : String?
	let updatedAt : String?
	let createdAt : String?

	enum CodingKeys: String, CodingKey {
        case id = "_id"
        case vendorId = "vendor_id"
        case orderId = "order_id"
        case consumerId = "consumer_id"
        case items = "items"
        case totalAmount = "total_amount"
        case totalCommission = "total_commission"
        case returnFeePercentage = "return_fee_percentage"
        case reason = "reason"
        case comments = "comments"
        case status = "status"
		case updatedAt = "updated_at"
		case createdAt = "created_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        vendorId = try values.decodeIfPresent(String.self, forKey: .vendorId)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
        items = try values.decodeIfPresent([Item].self, forKey: .items)
        totalAmount = try values.decodeIfPresent(Price.self, forKey: .totalAmount)
        totalCommission = try values.decodeIfPresent(Price.self, forKey: .totalCommission)
        returnFeePercentage = try values.decodeIfPresent(Int.self, forKey: .returnFeePercentage)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        status = try values.decodeIfPresent(String.self, forKey: .status)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
	}

}
