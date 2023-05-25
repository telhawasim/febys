//
//  VendorRatingTableViewCell.swift
//  febys
//
//  Created by Nouman Akram on 21/12/2021.
//

import UIKit
import Cosmos

protocol ProductRatingDelegate {
    func addProductReview(of skuId: String, rating: Double, comment: String)
}

class ProductRatingTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: FebysLabel!
    @IBOutlet weak var productSkuId: FebysLabel!
    @IBOutlet weak var productRatingStars: CosmosView!
    @IBOutlet weak var reviewComment: UITextView!
    
    //MARK: Variable
    var skuId = ""
    var rating = 5.0
    var comment = ""
    var delegate: ProductRatingDelegate?
    
    //MARK: LIFECYCLE
    override func awakeFromNib() {
        super.awakeFromNib()
        self.reviewComment.delegate = self
        self.productRatingStars.didFinishTouchingCosmos = { rating in
            self.rating = rating
            self.delegate?.addProductReview(of: self.skuId, rating: self.rating, comment: self.comment)
        }
    }
    
    //MARK: Helpers
    func configureProductReview(isEdititng: Bool) {
        self.productRatingStars.isUserInteractionEnabled = isEdititng
        self.reviewComment.isUserInteractionEnabled = isEdititng
    }

    //MARK: Configure
    func configure(_ products: Products?, hasReviewed: Bool?, isEditing: Bool) {
        if hasReviewed ?? false {
            self.configureProductReview(isEdititng: isEditing)
        }
        
        if let url = products?.product?.variants?.first?.images?.first {
            self.productImage.setImage(url: url)
        } else {
            self.productImage.image = UIImage(named: "no-image")
        }
        
        self.skuId = products?.product?.variants?.first?.skuId ?? ""
        self.rating = products?.ratingAndReview?.score ?? 5.0
        self.comment = products?.ratingAndReview?.review?.comment ?? ""
        
        self.productSkuId.text = self.skuId
        self.productName.text = products?.product?.name ?? ""
        self.productRatingStars.rating = self.rating
        self.reviewComment.text = self.comment
    }
}

extension ProductRatingTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.comment = textView.text.trim()
        self.delegate?.addProductReview(of: self.skuId, rating: self.rating, comment: self.comment)
    }
}
