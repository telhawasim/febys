
import Foundation

struct Sales : Codable {
	let currency : String?
	let value : Double?

	enum CodingKeys: String, CodingKey {

		case currency = "currency"
		case value = "value"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		currency = try values.decodeIfPresent(String.self, forKey: .currency)
		value = try values.decodeIfPresent(Double.self, forKey: .value)
	}

}
