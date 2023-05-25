//
//  PackagesTableViewCell.swift
//  febys
//
//  Created by Nouman Akram on 01/02/2022.
//

import UIKit

class PackagesTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var packageImageView: UIImageView!
    @IBOutlet weak var packageNameLabel: FebysLabel!
    @IBOutlet weak var packageTypeLabel: FebysLabel!
    @IBOutlet weak var packageDaysLabel: FebysLabel!
    @IBOutlet weak var packagePriceLabel: FebysLabel!
    @IBOutlet weak var packageActiveLabel: FebysLabel!

    //MARK: Variables
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Helper
    func didHideActiveTag(_ isHidden: Bool) {
        self.packageActiveLabel.isHidden = isHidden ? true : false
    }
    
    func setSelectedState(isSelected: Bool) {
        if isSelected {
            self.mainView.borderColor = .febysRed()
            self.mainView.borderWidth = 2
        } else {
            self.mainView.borderColor = .febysMildGreyColor()
            self.mainView.borderWidth = 1
        }
    }
    
    func configurePackageUI(_ package: Package?, isSubscribed: Bool) {
        if isSubscribed {
            if package?.isSubscribed ?? false {
                self.contentView.alpha = 1
                self.isUserInteractionEnabled = false
                self.setSelectedState(isSelected: true)
                self.didHideActiveTag(false)
            } else {
                self.contentView.alpha = 0.25
                self.isUserInteractionEnabled = false
                self.setSelectedState(isSelected: false)
                self.didHideActiveTag(true)
            }
        } else {
            self.contentView.alpha = 1
            self.isUserInteractionEnabled = true
            self.didHideActiveTag(true)
        }
    }
    
    //MARK: Configure Data
    func configure(_ package: Package?, isSelected: Bool, isSubscribed: Bool){
        self.setSelectedState(isSelected: isSelected)
        self.configurePackageUI(package, isSubscribed: isSubscribed)
        self.packageNameLabel.text = package?.title
        self.packageTypeLabel.text = package?.features?.first?.title
        self.packageDaysLabel.text = "\(package?.subscriptionDays ?? 0) Days"
        self.packagePriceLabel.text = package?.price?.formattedPrice()
    
        if let url = package?.icon {
            self.packageImageView.setImage(url: url)
        } else {
            self.packageImageView.image = UIImage(named: "user.png")
        }
    }
}
