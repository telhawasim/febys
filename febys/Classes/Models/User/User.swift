
import Foundation

struct User : Codable {
    let id : Int?
    let first_name : String?
    let last_name : String?
    let email : String?
    let keycloak_id : String?
    let phone_number : PhoneNumbers?
    let units_purchased : Int?
    let sale_value : Double?
    let sale_currency : String?
    let is_verified : Int?
    let deleted : Int?
    let created_at : String?
    let updated_at : String?
    let profile_image : String?
    let notificationsStatus: Int?
    var access_token : String?
    var refresh_token: String?
    var expires_in : Int?
    var refresh_expires_in : Int?
    var token_type : String?
    var session_state : String?
    var scope : String?
    
    static var payment_id : String? = "PAY-001"
    
    func save() -> Bool {
        return User.saveProfile(self)
    }
    
    static func saveProfile(_ value: User?)->Bool {
        let defaults = UserDefaults()
        if value == nil {
            defaults.set(nil, forKey: Constants.user)
            return defaults.synchronize()
        }
        do {
            let data = try JSONEncoder().encode(value)
            
            defaults.set(data, forKey: Constants.user)
            return defaults.synchronize()
        }
        catch let error {
            print(error.localizedDescription)
            return false
        }
    }

    static func fetch() -> User? {
        let userDefaults = UserDefaults()
        guard let data = userDefaults.data(forKey: Constants.user) else {
            return nil
        }
        return try? JSONDecoder().decode(User.self, from: data)
    }
    
    static func remove() {
        let userDefaults = UserDefaults()
        if (userDefaults.object(forKey: Constants.user) != nil) {
            userDefaults.removeObject(forKey: Constants.user)
        }
    }
}
