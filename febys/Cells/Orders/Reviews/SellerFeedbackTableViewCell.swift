//
//  TableViewCell.swift
//  febys
//
//  Created by Nouman Akram on 21/12/2021.
//

import UIKit
import Cosmos

protocol SellerFeedbackDelegate {
    func addVendorReview(priceRating: Double, valueRating: Double, qualityRating: Double, comment: String)
}

class SellerFeedbackTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var priceRatingStars: CosmosView!
    @IBOutlet weak var valueRatingStars: CosmosView!
    @IBOutlet weak var qualityRatingStars: CosmosView!
    @IBOutlet weak var reviewComment: UITextView!
    
    var delegate: SellerFeedbackDelegate?
    
    var priceRating = 5.0
    var valueRating = 5.0
    var qualityRating = 5.0
    var comment = ""

    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextFields()
        configureRatingStarsCallbacks()
    }
    
    //MARK: Configure
    func configureTextFields() {
        self.reviewComment.delegate = self
    }
    
    func configureRatingStarsCallbacks() {
        self.priceRatingStars.didFinishTouchingCosmos = { rating in
            self.priceRating = rating
            self.delegate?.addVendorReview(priceRating: self.priceRating, valueRating: self.valueRating, qualityRating: self.qualityRating, comment: self.comment)
        }
        
        self.valueRatingStars.didFinishTouchingCosmos = { rating in
            self.valueRating = rating
            self.delegate?.addVendorReview(priceRating: self.priceRating, valueRating: self.valueRating, qualityRating: self.qualityRating, comment: self.comment)
        }
        
        self.qualityRatingStars.didFinishTouchingCosmos = { rating in
            self.qualityRating = rating
            self.delegate?.addVendorReview(priceRating: self.priceRating, valueRating: self.valueRating, qualityRating: self.qualityRating, comment: self.comment)
        }
    }
    
    func configureSellerFeedback(isEdititng: Bool) {
        self.priceRatingStars.isUserInteractionEnabled = isEdititng
        self.valueRatingStars.isUserInteractionEnabled = isEdititng
        self.qualityRatingStars.isUserInteractionEnabled = isEdititng
        self.reviewComment.isUserInteractionEnabled = isEdititng
    }
     
    func configure(_ reviews: RatingsAndReviews?, hasReviewed: Bool?, isEdititng: Bool) {
        if hasReviewed ?? false {
            self.configureSellerFeedback(isEdititng: isEdititng)
        }
        
        self.priceRating = reviews?.pricingScore ?? 5.0
        self.valueRating = reviews?.valueScore ?? 5.0
        self.qualityRating = reviews?.qualityScore ?? 5.0
        self.comment = reviews?.review?.comment ?? ""
        
        self.priceRatingStars.rating = self.priceRating
        self.valueRatingStars.rating = self.valueRating
        self.qualityRatingStars.rating = self.qualityRating
        self.reviewComment.text =  self.comment
    }
}

extension SellerFeedbackTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.comment = textView.text.trim()
        self.delegate?.addVendorReview(priceRating: self.priceRating, valueRating: self.valueRating, qualityRating: self.qualityRating, comment: self.comment)
    }
}
