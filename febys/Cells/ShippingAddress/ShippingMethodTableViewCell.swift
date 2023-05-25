//
//  ShippingMethodTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 24/08/2022.
//

import UIKit

class ShippingMethodTableViewCell: UITableViewCell {

    //MARK: OUTLETS
    @IBOutlet weak var estimateCardView: UIView!
    @IBOutlet weak var estimateImageView: UIImageView!
    @IBOutlet weak var estimateTitleLabel: FebysLabel!
    @IBOutlet weak var estimateDeliveryLabel: FebysLabel!
    @IBOutlet weak var estimatePriceLabel: FebysLabel!
    @IBOutlet weak var radioButton: UIButton!
    
    //MARK: CONFIGURE
    func configure(_ estimate: Estimate?, isSelected: Bool) {
        self.setCellSelection(isSelected)
        
        var price = Price()
        price.currency = estimate?.totalPricing?.currencyCode ?? Defaults.currency
        price.value = estimate?.totalPricing?.value ?? Defaults.double

        if let url = estimate?.estimateTypeDetails?.icon {
            estimateImageView.setImage(url: url)
        } else {
            estimateImageView.image = UIImage(named: "no-image")
        }
        
        estimateTitleLabel.text = estimate?.estimateTypeDetails?.name?.capitalized
        estimateDeliveryLabel.text = estimate?.timeString
        estimatePriceLabel.text = price.formattedPrice()
        
    }
    
    //MARK: METHODS
    func setCellSelection(_ selected: Bool) {
        radioButton.isSelected = selected
        estimateCardView.borderColor = selected ? .febysRed() : .febysMildGreyColor()
    }
    
}
