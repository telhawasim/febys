import Foundation

struct Message : Codable {
    var vendorId : String?
	var message : String?

	enum CodingKeys: String, CodingKey {
		case vendorId = "vendor_id"
		case message = "message"
	}
    
    init() {}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		vendorId = try values.decodeIfPresent(String.self, forKey: .vendorId)
		message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}
