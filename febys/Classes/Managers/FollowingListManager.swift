//
//  WishlistManager.swift
//  febys
//
//  Created by Ab Saqib on 05/08/2021.
//

import UIKit

class FollowingListManager: NSObject{
    
    //MARK:- PROPERTIES
    static var shared = FollowingListManager()
    
    private var vendorIds = [String]()
    
    private override init() {
        super.init()
        self.getAllFollowingIds()
    }
    
    //MARK:- Api Callings
    func getAllFollowingIds(){
        if let followings = UserInfo.fetch()?.followings?.followings {
            self.vendorIds = followings
        }
    }
    
    func followOrUnfollowVendor(_ sender: UIButton, by id: String) {
        if User.fetch() != nil {
            sender.isSelected.toggle()
            if sender.isSelected {
                FollowingListManager.shared.followVendorBy(id: id)
            } else {
                FollowingListManager.shared.unfollowVendorBy(id: id)
            }
            NotificationCenter.default.post(name: .followUpdated, object: nil)
        } else {
            RedirectionManager.shared.goToLogin()
        }
    }
    
    func followVendorBy(id: String, onSuccess: (() -> Void)? = nil) {
        vendorIds.append(id)
        FollowService.shared.addToFollowList(id: id) { result in
            switch result {
            case .success(_):
                onSuccess?()
            case .failure(_):
                break
            }
        }
    }
    
    func unfollowVendorBy(id: String, onSuccess: (() -> Void)? = nil){
        vendorIds.removeAll(where: {$0 == id})
        FollowService.shared.removeFromFollowList(id: id) { result in
            switch result {
            case .success(_):
                onSuccess?()
            case .failure(_):
                break
            }
        }
    }
    
    func isFollowed(vendorId: String) -> Bool {
        return self.vendorIds.first(where: {$0 == vendorId}) != nil
    }
}
