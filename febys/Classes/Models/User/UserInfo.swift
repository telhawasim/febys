import Foundation

struct UserInfo : Codable {
    var consumerInfo : User?
	let wishList : WishListResponse?
	let recentlyViewed : RecentlyViewed?
	let followings : Following?
	let shippingDetails : [ShippingDetails]?
	let vouchers : [Vouchers]?
    var wallet : Wallet?
    var subscription : Subscription?
    var notificationCounts : NotificationCount?

	enum CodingKeys: String, CodingKey {
		case consumerInfo = "consumer_info"
		case wishList = "wishList"
		case recentlyViewed = "recently_viewed"
		case followings = "followings"
		case shippingDetails = "shipping_details"
		case vouchers = "vouchers"
        case wallet = "wallet"
        case subscription = "subscription"
        case notificationCounts = "notifications_counts"

    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		consumerInfo = try values.decodeIfPresent(User.self, forKey: .consumerInfo)
		wishList = try values.decodeIfPresent(WishListResponse.self, forKey: .wishList)
		recentlyViewed = try values.decodeIfPresent(RecentlyViewed.self, forKey: .recentlyViewed)
		followings = try values.decodeIfPresent(Following.self, forKey: .followings)
		shippingDetails = try values.decodeIfPresent([ShippingDetails].self, forKey: .shippingDetails)
		vouchers = try values.decodeIfPresent([Vouchers].self, forKey: .vouchers)
        wallet = try values.decodeIfPresent(Wallet.self, forKey: .wallet)
        subscription = try values.decodeIfPresent(Subscription.self, forKey: .subscription)
        notificationCounts = try values.decodeIfPresent(NotificationCount.self, forKey: .notificationCounts)

    }
    
    
    func save() -> Bool {
        return UserInfo.saveUserInfo(self)
    }
    
    static func saveUserInfo(_ value: UserInfo?)->Bool {
        let defaults = UserDefaults()
        if value == nil {
            defaults.set(nil, forKey: Constants.userInfo)
            return defaults.synchronize()
        }
        do {
            let data = try JSONEncoder().encode(value)
            
            defaults.set(data, forKey: Constants.userInfo)
            return defaults.synchronize()
        }
        catch let error {
            print(error.localizedDescription)
            return false
        }
    }

    static func fetch() -> UserInfo? {
        let userDefaults = UserDefaults()
        guard let data = userDefaults.data(forKey: Constants.userInfo) else {
            return nil
        }
        return try? JSONDecoder().decode(UserInfo.self, from: data)
    }
    
    static func remove() {
        let userDefaults = UserDefaults()
        if (userDefaults.object(forKey: Constants.userInfo) != nil) {
            userDefaults.removeObject(forKey: Constants.userInfo)
        }
    }
    
}
