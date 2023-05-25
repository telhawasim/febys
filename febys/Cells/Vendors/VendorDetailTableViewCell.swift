//
//  VendorDetailTableViewCell.swift
//  febys
//
//  Created by Abdul Kareem on 04/10/2021.
//

import UIKit
import Cosmos

class VendorDetailTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var templateBannerImageView: UIImageView!
    @IBOutlet weak var templateVendorImageView: UIImageView!
    @IBOutlet weak var vendorNameLabel: FebysLabel!
    @IBOutlet weak var vendorRoleLabel: FebysLabel!
    @IBOutlet weak var vendorRatingStars: CosmosView!
    @IBOutlet weak var vendorRatingLabel: FebysLabel!
    @IBOutlet weak var vendorAddressLabel: FebysLabel!
    @IBOutlet weak var vendorSocialsStackView: UIStackView!
    @IBOutlet weak var followButton: CustomFollowButton!
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureRatingStars()
        
        followButton.setBackgroundColor(color: .febysRed(), forState: .normal)
        followButton.setBackgroundColor(color: .clear, forState: .selected)
    }
    
    //MARK: Navigation
    func goToSocialApp(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let application = UIApplication.shared
        if application.canOpenURL(url) {
            application.open(url)
        } else {
            application.open(url)
        }
    }
    
    
    func configureRatingStars(){
        self.vendorRatingStars.settings.updateOnTouch = false
        self.vendorRatingStars.settings.fillMode = .precise
    }
    
    func configure(_ vendor: Vendor?, forVendor: Bool) {
        if forVendor {
            if let banner = vendor?.template?.first(where:{$0.section == "1,1"}) {
                if let url = banner.images?.first?.url,
                    vendor?.templatePublished ?? false {
                    self.templateBannerImageView.setImage(url: url)
                } else {
                    self.templateBannerImageView.image = UIImage(named: "banner.png")
                }
            }
        } else {
            if let banner = vendor?.template?.first(where:{$0.section == "topBanner"}) {
                if let url = banner.images?.first?.url,
                   vendor?.templatePublished ?? false {
                    self.templateBannerImageView.setImage(url: url)
                } else {
                    self.templateBannerImageView.image = UIImage(named: "banner.png")
                }
            }
        }
        
        if let url = vendor?.templatePhoto,
           vendor?.templatePublished ?? false {
            self.templateVendorImageView.setImage(url: url)
        } else {
            self.templateVendorImageView.image = UIImage(named: "user.png")
        }
        
        if let socials = vendor?.socials {
            if !socials.isEmpty {
                self.addSocialLinks(in: self.vendorSocialsStackView, from: socials)
            }
        }
        
        if User.fetch() != nil{
            self.followButton.isSelected = FollowingListManager.shared.isFollowed(vendorId: vendor?.id ?? "-1")
        } else {
            self.followButton.isSelected = false
        }
        
        let rating = vendor?.stats?.rating?.score
        self.didHideVendorRatingStars(forVendor ? false : true)
        self.vendorRatingStars.rating = rating ?? 0.0
        self.vendorRatingLabel.text = "(\(rating ?? 0.0)) Ratings"
        self.vendorNameLabel.text = vendor?.name ?? ""
        self.vendorRoleLabel.text = vendor?.role?.name ?? ""
        self.vendorAddressLabel.text = vendor?.businessInfo?.address ?? ""

    }
    
    //MARK: Helper
    
    func didHideVendorRatingStars(_ isHidden: Bool) {
        if isHidden {
            self.vendorRatingStars.isHidden = true
            self.vendorRatingLabel.isHidden = true
        } else {
            self.vendorRatingStars.isHidden = false
            self.vendorRatingLabel.isHidden = false
        }
    }
    
    func addSocialLinks(in stackView: UIStackView, from socials: [Social]) {
        stackView.removeAllArrangedSubviews()
        stackView.spacing = 5
        for social in socials {
            let socialValue = SocialLinks(rawValue: social.name ?? "")
            let button = self.getSocialButton(socialValue!)
            stackView.addArrangedSubview(button)
            
            button.didTap = { [weak self] in
                self?.goToSocialApp(urlString: social.url ?? "")
            }
        }
    }
    
    func getSocialButton(_ social: SocialLinks) -> FebysButton {
        let button = FebysButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: getSocialIcon(social)), for: .normal)
        return button
    }
    
    func getSocialIcon(_ social: SocialLinks) -> String{
        switch social {
        case .linkedIn:
            return "linkedinIcon"
        case .facebook:
            return "facebookIcon"
        case .instagram:
            return "instagramIcon"
        case .youtube:
            return "youtubeIcon"
        case .pinterest:
            return "pinterestIcon"
        case .twitter:
            return "twitterIcon"
        }
    }
}

 


enum SocialLinks : String {
    case linkedIn = "LinkedIn"
    case facebook = "Facebook"
    case instagram = "Instagram"
    case youtube = "Youtube"
    case pinterest = "Pinterest"
    case twitter = "Twitter"
}
