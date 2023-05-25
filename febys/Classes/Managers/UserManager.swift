//
//  UserManager.swift
//  febys
//
//  Created by Faisal Shahzad on 18/01/2022.
//

import Foundation
import UIKit

class UserManager: NSObject {
    
    //MARK:- PROPERTIES
    static var shared = UserManager()
    private var userInfo: UserInfo?
    
    var response: Bool?
    private var followedVendors: FollowResponse?
    private var vendorIds = [String]()
    
    private override init() {
        super.init()
//        self.fetchUserInfo()
    }
    
    //MARK:- Api Callings
    func fetchUserInfo(){
        UserService.shared.fetchUserInfo { response in
            switch response{
            case .success(let userInfo):
                self.userInfo = userInfo
                _ = userInfo.save()
                
                if ShippingDetails.fetch() == nil {
                    let shippingDetails = userInfo.shippingDetails?.first(where: { $0.shippingDetail?.isDefault ?? false})
                    _ = shippingDetails?.save()
                }
                
                if let user = userInfo.consumerInfo {
                    if let _ = user.notificationsStatus,
                       let userId = user.id {
                        FirebaseManager.shared.subscribeToTopic(userId)
                    }
                }
                
                if let notificationCounts = userInfo.notificationCounts,
                   let badgeCount = notificationCounts.badge {
                    UIApplication.shared.applicationIconBadgeNumber = badgeCount
                    RedirectionManager.shared.addOrRemoveNotificationBadge()
                }
                
                if let _ = userInfo.wishList?.variantSkuIds {
                    WishlistManager.shared.getWishlistItems()
                    NotificationCenter.default.post(name: .wishlistUpdated, object: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
