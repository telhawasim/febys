import Foundation

class ShippingDetails : Codable {
    let id : String?
    let consumerId : Int?
    let shippingDetail : ShippingDetail?
    let updatedAt : String?
    let createdAt : String?

	enum CodingKeys: String, CodingKey {
        case id = "_id"
        case consumerId = "consumer_id"
        case shippingDetail = "shipping_detail"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
        consumerId = try values.decodeIfPresent(Int.self, forKey: .consumerId)
        shippingDetail = try values.decodeIfPresent(ShippingDetail.self, forKey: .shippingDetail)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
		updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
	}
    
    func save() -> Bool {
        return ShippingDetails.saveAddress(self)
    }
    
    static func saveAddress(_ value: ShippingDetails?)->Bool {
        let defaults = UserDefaults()
        if value == nil {
            defaults.set(nil, forKey: Constants.shippingDetails)
            return defaults.synchronize()
        }
        do {
            let data = try JSONEncoder().encode(value)
            
            defaults.set(data, forKey: Constants.shippingDetails)
            return defaults.synchronize()
        }
        catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    static func fetch() -> ShippingDetails? {
        let userDefaults = UserDefaults()
        guard let data = userDefaults.data(forKey: Constants.shippingDetails) else {
            return nil
        }
        return try? JSONDecoder().decode(ShippingDetails.self, from: data)
    }
    
    static func remove() {
        let userDefaults = UserDefaults()
        if (userDefaults.object(forKey: Constants.shippingDetails) != nil) {
            userDefaults.removeObject(forKey: Constants.shippingDetails)
        }
    }

}
