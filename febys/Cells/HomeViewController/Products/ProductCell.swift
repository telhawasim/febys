//
//  ProductCell.swift
//  febys
//
//  Created by Waseem Nasir on 10/07/2021.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var originalStackView: UIStackView!
    @IBOutlet weak var originalPriceLabel: FebysLabel!
    @IBOutlet weak var savedPriceLabel: FebysLabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: FebysLabel!
    @IBOutlet weak var nameLabel: FebysLabel!
    @IBOutlet weak var priceLabel: FebysLabel!
    @IBOutlet weak var favouriteIcon: FebysButton!
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favouriteIcon.setImage(UIImage (named: "heart"), for: .normal)
        self.favouriteIcon.setImage(UIImage(named: "heartfill"), for: .selected)
    }
    
    //MARK: Helper
    func configure(product: Product? = nil , isLarge: Bool){
        let variants = product?.variants
        let variant = variants?.first(where: {$0.isDefault == true}) ?? variants?.first
        
        self.favouriteIcon.isHidden = isLarge ? true : false
        self.storeNameLabel.isHidden = isLarge ? false : true
        
        if let product = product {
            self.favouriteIcon.isSelected = WishlistManager.shared.isFavourite(variantId: variant?.skuId ?? "-1")
            
            if let url = variant?.images?.first {
                self.mainImageView.setImage(url: url)
            } else { self.mainImageView.image = UIImage(named: "no-image.png") }
            
            if let hasPromotion = variant?.hasPromotion {
                self.originalStackView.isHidden = hasPromotion ? false : true
                self.savedPriceLabel.isHidden = hasPromotion ? false : true
            }
            
            let savedAmount = getDifference(x: variant?.originalPrice?.value ?? 0.0, y: variant?.price?.value ?? 0.0)
            var savedPrice = Price()
            savedPrice.value = savedAmount
            savedPrice.currency = variant?.price?.currency
            
            self.storeNameLabel.text = product.vendorShopName
            self.nameLabel.text = product.name
            self.priceLabel.text = variant?.price?.formattedPrice()
            self.originalPriceLabel.text = variant?.originalPrice?.formattedPrice()
            self.originalPriceLabel.strikeThrough(true)
            self.savedPriceLabel.text = "Save \(savedPrice.formattedPrice() ?? "0.0")"
        }
        
        favouriteIcon.didTap = { [weak self] in
            if let id = variant?.skuId{
                WishlistManager.shared.addORRemoveFromWishlist((self?.favouriteIcon)!, variantId: id)
            }
        }
        
        self.mainStackView.setNeedsLayout()
    }
    
    func getDifference(x: Double, y: Double) -> Double {
        return (x - y).round(to: 2)
    }
}
