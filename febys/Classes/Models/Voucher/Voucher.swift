import Foundation

struct Voucher : Codable {
	let stats : Stats?
	let id : String?
	let code : String?
	let amountType : String?
	let amount : Double?
    let discount : Double?
	let startDate : String?
	let endDate : String?
	let active : Bool?
	let maxRedeemCount : Int?
	let maxUserRedeemCount : Int?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {
		case stats = "stats"
		case id = "_id"
		case code = "code"
		case amountType = "amount_type"
		case amount = "amount"
        case discount = "discount"
		case startDate = "start_date"
		case endDate = "end_date"
		case active = "active"
		case maxRedeemCount = "max_redeem_count"
		case maxUserRedeemCount = "max_user_redeem_count"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		stats = try values.decodeIfPresent(Stats.self, forKey: .stats)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		code = try values.decodeIfPresent(String.self, forKey: .code)
		amountType = try values.decodeIfPresent(String.self, forKey: .amountType)
		amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        discount = try values.decodeIfPresent(Double.self, forKey: .discount)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
		endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
		active = try values.decodeIfPresent(Bool.self, forKey: .active)
        maxRedeemCount = try values.decodeIfPresent(Int.self, forKey: .maxRedeemCount)
        maxUserRedeemCount = try values.decodeIfPresent(Int.self, forKey: .maxUserRedeemCount)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
