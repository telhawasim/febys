//
//  ShoppingCartCell.swift
//  febys
//
//  Created by Faisal Shahzad on 16/09/2021.
//

import UIKit

class ShoppingCartCell: UITableViewCell {
    
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartCrossBtn: FebysButton!
    @IBOutlet weak var cartProductDetail: FebysLabel!
    @IBOutlet weak var cartItemId: FebysLabel!
    @IBOutlet weak var favouriteCartButton: FebysButton!
    @IBOutlet weak var cartItemPrice: FebysLabel!
    @IBOutlet weak var quantityCountLabel: FebysTextField!
    @IBOutlet weak var decreaseQuantityButton: FebysButton!
    @IBOutlet weak var increaseQuantityButton: FebysButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favouriteCartButton.setImage(UIImage(named: "heart"), for: .normal)
        self.favouriteCartButton.setImage(UIImage(named: "heartfill"), for: .selected)
    }
    
    //MARK: Helper
    func didHideWishlist(_ hidden: Bool) {
        if hidden { favouriteCartButton.isHidden = true }
        else { favouriteCartButton.isHidden = false }
    }
    
    //MARK: Configuration
    func configureForCart(_ cart: CartEntity) {
        var price = Price()
        price.value = cart.price * Double(cart.quantity)
        price.currency = cart.currency
        
        self.didHideWishlist(false)
        self.cartProductDetail.text = cart.name ?? "no name"
        self.cartItemId.text = cart.skuId?.trim()
        self.cartItemPrice.text = price.formattedPrice()
        self.cartImage.setImage(url: cart.imageURL ?? "")
        self.quantityCountLabel.text = "\(cart.quantity)"
    }
    
    func configureForCheckout(_ product: Product?, qty: Int?) {
        self.didHideWishlist(true)
        self.cartProductDetail.text = product?.name ?? "no name"
        self.cartItemId.text = product?.variants?.first?.skuId?.trim()
        self.cartItemPrice.text = product?.variants?.first?.price?.formattedPrice()
        
        if let qty = qty {
            self.quantityCountLabel.text = "\(qty)"
            if qty <= 1 {
                decreaseQuantityButton.isEnabled = false
            } else {
                decreaseQuantityButton.isEnabled = true
            }
        }
        
        if let url = product?.variants?.first?.images?.first {
            self.cartImage.setImage(url: url)
        } else {
            self.cartImage.image = UIImage(named: "no-image")
        }
    }
    
    func configureForWishlist(id: String){
        self.favouriteCartButton.isSelected = WishlistManager.shared.isFavourite(variantId: id)
        
        favouriteCartButton.didTap = { [weak self] in
            WishlistManager.shared.addORRemoveFromWishlist((self?.favouriteCartButton)!, variantId: id)
        }
    }
}
