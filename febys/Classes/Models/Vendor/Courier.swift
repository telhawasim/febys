import Foundation

struct Courier : Codable {
	let service : Service?
	let trackingId : String?

	enum CodingKeys: String, CodingKey {

		case service = "service"
		case trackingId = "tracking_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		service = try values.decodeIfPresent(Service.self, forKey: .service)
		trackingId = try values.decodeIfPresent(String.self, forKey: .trackingId)
	}

}
