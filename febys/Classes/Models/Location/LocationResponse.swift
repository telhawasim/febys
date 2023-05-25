import Foundation

struct LocationResponse : Codable {
	let countries : [MyLocation]?
    let states : [MyLocation]?
    let cities : [MyLocation]?

	enum CodingKeys: String, CodingKey {
		case countries = "countries"
        case states = "states"
        case cities = "cities"

	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		countries = try values.decodeIfPresent([MyLocation].self, forKey: .countries)
        states = try values.decodeIfPresent([MyLocation].self, forKey: .states)
        cities = try values.decodeIfPresent([MyLocation].self, forKey: .cities)
	}

}
