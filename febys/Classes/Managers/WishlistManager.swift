//
//  WishlistManager.swift
//  febys
//
//  Created by Ab Saqib on 05/08/2021.
//

import UIKit

class WishlistManager: NSObject{
    
    //MARK:- PROPERTIES
    static var shared = WishlistManager()
    private var variantIds = [String]()
    
    private override init() {
        super.init()
        self.getWishlistItems()
    }
    
    //MARK:- Api Callings
    func getWishlistItems(){
        if let wishlistIds = UserInfo.fetch()?.wishList?.variantSkuIds {
            self.variantIds = wishlistIds
        }
    }
    
    func getWishlistItemCount() -> Int {
        return variantIds.count
    }
    
    func addORRemoveFromWishlist(_ sender: UIButton, variantId: String) {
        if User.fetch() != nil {
            sender.isSelected.toggle()
            if sender.isSelected {
                WishlistManager.shared.addToWishlist(variantId: variantId)
            } else{
                WishlistManager.shared.removefromWishlist(variantId: variantId)
            }
        } else {
            RedirectionManager.shared.goToLogin()
        }
    }
    
    func addToWishlist(variantId: String, onSuccess: (() -> Void)? = nil) {
        let bodyParams = [ParameterKeys.sku_ids: [variantId]]
        variantIds.append(variantId)
        NotificationCenter.default.post(name: .wishlistUpdated, object: nil)
        WishListService.shared.addToWishList(body: bodyParams) { result in
            switch result {
            case .success(_):
                onSuccess?()
            case .failure(_):
                break
            }
        }
    }
    
    func removefromWishlist(variantId: String, onSuccess: (() -> Void)? = nil){
        variantIds.removeAll(where: {$0 == variantId})
        let bodyParams = [ParameterKeys.sku_ids: [variantId]]
        NotificationCenter.default.post(name: .wishlistUpdated, object: nil)
        WishListService.shared.removeFromWishList(body: bodyParams) { result in
            switch result {
            case .success(_):
                onSuccess?()
            case .failure(_):
                break
            }
        }
    }
    
    func clearWishList(){
        variantIds.removeAll()
        NotificationCenter.default.post(name: .wishlistUpdated, object: nil)
    }
    
    func isFavourite(variantId: String) -> Bool {
        return self.variantIds.first(where: {$0 == variantId}) != nil
    }
}
