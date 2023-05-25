import Foundation

class Address : Codable {
	let street : String?
	let city : String?
	let state : String?
	let zipCode : String?
	let countryCode : String?
    let location : Location?

	enum CodingKeys: String, CodingKey {

		case street = "street"
		case city = "city"
		case state = "state"
		case zipCode = "zip_code"
		case countryCode = "country_code"
        case location = "location"

	}

}
