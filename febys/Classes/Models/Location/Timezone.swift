import Foundation

struct Timezone : Codable {
	let zoneName : String?
	let gmtOffset : Int?
	let gmtOffsetName : String?
	let abbreviation : String?
	let tzName : String?

	enum CodingKeys: String, CodingKey {

		case zoneName = "zoneName"
		case gmtOffset = "gmtOffset"
		case gmtOffsetName = "gmtOffsetName"
		case abbreviation = "abbreviation"
		case tzName = "tzName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		zoneName = try values.decodeIfPresent(String.self, forKey: .zoneName)
		gmtOffset = try values.decodeIfPresent(Int.self, forKey: .gmtOffset)
		gmtOffsetName = try values.decodeIfPresent(String.self, forKey: .gmtOffsetName)
		abbreviation = try values.decodeIfPresent(String.self, forKey: .abbreviation)
		tzName = try values.decodeIfPresent(String.self, forKey: .tzName)
	}

}
