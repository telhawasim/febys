//
//  CollectionViewCell.swift
//  FebysUIDemo
//
//  Created by Ab Saqib on 12/07/2021.
//

import UIKit

class ProductItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImage:UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemBrand: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var cellButton: FebysButton!
    @IBOutlet weak var originalPriceLabel: FebysLabel!
    @IBOutlet weak var savedPriceLabel: FebysLabel!
    @IBOutlet weak var originalPriceStackView: UIStackView!

    func configure(product: Product?, forWishlist: Bool = false){
        let variants = product?.variants
        var variant: Variant?
        if forWishlist {
            variant = variants?.first
        } else {
            variant = variants?.first(where: {$0.isDefault == true}) ?? variants?.first
        }
        
        if let url = variant?.images?.first {
            self.itemImage.setImage(url: url)
        } else {
            self.itemImage.image = UIImage(named: "no-image")
        }
        
        if let hasPromotion = variant?.hasPromotion {
            self.originalPriceStackView.isHidden = hasPromotion ? false : true
            self.savedPriceLabel.isHidden = hasPromotion ? false : true
        }
        
        let savedAmount = getDifference(x: variant?.originalPrice?.value ?? 0.0, y: variant?.price?.value ?? 0.0)
        var savedPrice = Price()
        savedPrice.value = savedAmount
        savedPrice.currency = variant?.price?.currency
        
        self.itemBrand.text = product?.vendorShopName
        self.itemName.text = product?.name
        self.itemPrice.text = variant?.price?.formattedPrice() ?? ""
        self.originalPriceLabel.text = variant?.originalPrice?.formattedPrice()
        self.originalPriceLabel.strikeThrough(true)
        self.savedPriceLabel.text = "Save \(savedPrice.formattedPrice() ?? "0.0")"

        if forWishlist {
            self.cellButton.setImage(UIImage(named: "wislistcross"), for: .normal)
        } else {
            self.cellButton.setImage(UIImage(named: "heart"), for: .normal)
            self.cellButton.setImage(UIImage(named: "heartfill"), for: .selected)
            self.cellButton.isSelected = WishlistManager.shared.isFavourite(variantId: variant?.skuId ?? "-1")
        }

        cellButton.didTap = { [weak self] in
            if let id = variant?.skuId{
                if forWishlist {
                    WishlistManager.shared.removefromWishlist(variantId: id)
                } else {
                    WishlistManager.shared.addORRemoveFromWishlist((self?.cellButton)!, variantId: id)
                }
            }
        }
    }
    
    func getDifference(x: Double, y: Double) -> Double {
        return (x - y).round(to: 2)
    }
}
