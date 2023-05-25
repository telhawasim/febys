import Foundation

struct MyLocation : Codable {
	let isoCode : String?
	let name : String?
	let phonecode : String?
    let countryCode : String?
    let stateCode : String?
    let flag : String?
    let currency : String?
    let latitude : String?
    let longitude : String?
    let timezones : [Timezone]?
    

	enum CodingKeys: String, CodingKey {
		case isoCode = "isoCode"
		case name = "name"
		case phonecode = "phonecode"
        case countryCode = "countryCode"
        case stateCode = "stateCode"
        case flag = "flag"
		case currency = "currency"
		case latitude = "latitude"
		case longitude = "longitude"
		case timezones = "timezones"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		isoCode = try values.decodeIfPresent(String.self, forKey: .isoCode)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		phonecode = try values.decodeIfPresent(String.self, forKey: .phonecode)
        countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
        stateCode = try values.decodeIfPresent(String.self, forKey: .stateCode)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
		currency = try values.decodeIfPresent(String.self, forKey: .currency)
		latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
		timezones = try values.decodeIfPresent([Timezone].self, forKey: .timezones)
	}

}
