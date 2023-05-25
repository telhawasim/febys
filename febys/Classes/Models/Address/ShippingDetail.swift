import Foundation

class ShippingDetail : Codable {
    let id : String?
    let email : String?
    let firstName : String?
    let lastName : String?
    let label : String?
    let address : Address?
    let contact : PhoneNumbers?
    let isDefault : Bool?
	let updatedAt : String?
	let createdAt : String?

	enum CodingKeys: String, CodingKey {

		case address = "address"
		case label = "label"
		case contact = "contact"
		case firstName = "first_name"
		case lastName = "last_name"
		case email = "email"
		case isDefault = "default"
		case id = "_id"
		case updatedAt = "updated_at"
		case createdAt = "created_at"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(Address.self, forKey: .address)
		label = try values.decodeIfPresent(String.self, forKey: .label)
		contact = try values.decodeIfPresent(PhoneNumbers.self, forKey: .contact)
		firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		isDefault = try values.decodeIfPresent(Bool.self, forKey: .isDefault)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
		createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
	}

}
