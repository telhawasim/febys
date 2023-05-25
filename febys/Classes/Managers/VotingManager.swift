//
//  VotingManager.swift
//  febys
//
//  Created by Faisal Shahzad on 05/11/2021.
//

import UIKit

class VotingManager: NSObject {
    
    //MARK:- PROPERTIES
    static var shared = VotingManager()
    private var wishListProducts: ProductResponse?
    private var variantIds = [String]()

    
    var response: Bool?
    private var followedVendors: FollowResponse?
    private var vendorIds = [String]()
    
    private override init() {
        super.init()
        self.getAllFollowingIds()
    }
    
    //MARK:- Api Callings
    func getAllFollowingIds(){
        FollowService.shared.fetchAllFollowingIds { response in
            switch response{
            case .success(let following):
                _ = following.followings?.compactMap({ vendorId in
                    self.vendorIds.append(vendorId)
                })
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func followVendor(_ sender: UIButton, by id: String) {
        if User.fetch() != nil {
            sender.isSelected.toggle()
            if sender.isSelected {
                FollowingListManager.shared.followVendorBy(id: id)
            }
            else{
                FollowingListManager.shared.unfollowVendorBy(id: id)
            }
        } else {
            RedirectionManager.shared.goToLogin()
        }
    }
    
    func followVendorBy(id: String) {
        vendorIds.append(id)
        FollowService.shared.addToFollowList(id: id) { Result in
        }
    }
    
    func unfollowVendorBy(id: String){
        vendorIds.removeAll(where: {$0 == id})
        FollowService.shared.removeFromFollowList(id: id) { Result in
        }
    }
    
    func isFollowed(vendorId: String) -> Bool {
        return self.vendorIds.first(where: {$0 == vendorId}) != nil
    }
}
