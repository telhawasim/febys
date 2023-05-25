//
//  VendorStoreCell.swift
//  febys
//
//  Created by Ab Saqib on 06/09/2021.
//

import UIKit
import Cosmos
import SwiftUI

class VendorTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var storeRating: CosmosView!
    @IBOutlet weak var storeProfileImage: UIImageView!
    @IBOutlet weak var storeNameLabel: FebysLabel!
    @IBOutlet weak var storeFollowButton: CustomFollowButton!
    @IBOutlet weak var storeAddressLabel: FebysLabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var officialBadgeImage: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var vendorDetailStackView: UIStackView!
    @IBOutlet weak var followButtonStackView: UIStackView!
    @IBOutlet weak var storeDetailStackView: UIStackView!
    
    //MARK: LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureFollowButtonState()
        self.storeRating.settings.updateOnTouch = false
        self.storeRating.settings.fillMode = .precise
    }
    
    func configureFollowButtonState(){
        storeFollowButton.setBackgroundColor(color: .febysRed(), forState: .normal)
        storeFollowButton.setBackgroundColor(color: .clear, forState: .selected)
        
    }
    
    func configure(_ vendor: Vendor?, isFollowing: Bool, isVendor: Bool){
        if isFollowing {
            storeFollowButton.isSelected = true
            didHideFollowButton(false)
        } else {
            storeFollowButton.isSelected = false
            didHideFollowButton(true)
        }
        
        if let url = vendor?.businessInfo?.logo {
            self.storeProfileImage.setImage(url: url, placeholder: "user.png")
        } else {
            self.storeProfileImage.image = UIImage(named: "user.png")
        }
        
        if let isOfficial = vendor?.official {
            self.officialBadgeImage.isHidden = isOfficial ? false : true
        }
        
        if isVendor {
            self.didHideRatingStars(false)
            self.storeRating.rating = vendor?.stats?.rating?.score ?? 0.0
            self.storeDetailStackView.spacing = 1
            self.storeNameLabel.numberOfLines = 1
            self.storeAddressLabel.numberOfLines = 1
            self.storeAddressLabel.textColor = .febysRed()
            self.storeNameLabel.text = vendor?.shopName ?? ""
            self.storeAddressLabel.text = vendor?.role?.name ?? ""
            
        } else {
            self.didHideRatingStars(true)
            self.storeDetailStackView.spacing = 8
            self.storeNameLabel.numberOfLines = 1
            self.storeAddressLabel.numberOfLines = 2
            self.storeAddressLabel.textColor = .black
            self.storeNameLabel.text = vendor?.name ?? ""
            self.storeAddressLabel.text = vendor?.businessInfo?.address ?? ""
        }
        
        self.followButtonStackView.layoutIfNeeded()
        self.vendorDetailStackView.layoutIfNeeded()
        self.storeDetailStackView.layoutIfNeeded()
        self.mainStackView.layoutIfNeeded()
        
    }
    
    func didHideFollowButton(_ isHidden: Bool){
        if isHidden {
            self.storeFollowButton.isHidden = true
            self.arrowImage.isHidden = false
        } else {
            self.storeFollowButton.isHidden = false
            self.arrowImage.isHidden = true
        }
    }
    
    func didHideRatingStars(_ isHidden: Bool){
        if isHidden { self.storeRating.isHidden = true }
        else { self.storeRating.isHidden = false }
    }
}
