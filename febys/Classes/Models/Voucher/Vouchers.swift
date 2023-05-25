import Foundation

struct Vouchers : Codable {
	let id : String?
	let consumerId : Int?
	let voucherActive : Bool?
	let voucher : Voucher?
	let createdAt : String?
	let updatedAt : String?

	enum CodingKeys: String, CodingKey {

		case id = "_id"
		case consumerId = "consumer_id"
		case voucherActive = "voucherActive"
		case voucher = "voucher"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
		voucherActive = try values.decodeIfPresent(Bool.self, forKey: .voucherActive)
		voucher = try values.decodeIfPresent(Voucher.self, forKey: .voucher)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}

}
