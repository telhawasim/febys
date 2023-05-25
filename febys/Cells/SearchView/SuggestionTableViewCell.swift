//
//  SuggestionTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 25/07/2022.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {
    
    //MARK: OUTLETS
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: FebysLabel!
    @IBOutlet weak var productCategory: FebysLabel!
    @IBOutlet weak var storeName: FebysLabel!
    @IBOutlet weak var productPrice: FebysLabel!
    @IBOutlet weak var productOriginalPrice: FebysLabel!
    @IBOutlet weak var originalPriceView: UIStackView!
    @IBOutlet weak var dividerView: UIView!


    //MARK: LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: METHODS
    func hideOriginalPrice(_ isHidden: Bool) {
        originalPriceView.isHidden = isHidden
    }
    
    func didHideDivider(_ isHidden: Bool) {
        dividerView.backgroundColor = isHidden ? .clear : .febysMildGreyColor()
    }
    
    //MARK: CONFIGURE
    func configure(with suggestion: Suggesstion?) {
        if let product = suggestion {

            if let img = product.productImage { self.productImageView.setImage(url: img)
            } else {
                self.productImageView.image = UIImage(named: "no-image.png")
            }
            
            self.productTitle.text = product.productName ?? ""
            self.productCategory.text = product.categoryName ?? ""
            self.storeName.text = product.vendorName
            self.productPrice.text = product.price?.formattedPrice()
            self.productOriginalPrice.text = product.originalPrice?.formattedPrice()
            self.productOriginalPrice.strikeThrough(true)
            self.hideOriginalPrice(!(product.hasPromotion ?? false))

        }
    }
}
