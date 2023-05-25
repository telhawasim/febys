//
//  ReviewsViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 04/11/2021.
//

import UIKit
import CloudKit

class ReviewsViewCell: UIView {
    //MARK: IBOutlets
    @IBOutlet weak var avarageRatingLabel: FebysLabel!
    
    @IBOutlet weak var oneStarCount: FebysLabel!
    @IBOutlet weak var twoStarCount: FebysLabel!
    @IBOutlet weak var threeStarCount: FebysLabel!
    @IBOutlet weak var fourStarCount: FebysLabel!
    @IBOutlet weak var fiveStarCount: FebysLabel!

    @IBOutlet weak var oneStarProgressBar: UIProgressView!
    @IBOutlet weak var twoStarProgressBar: UIProgressView!
    @IBOutlet weak var threeStarProgressBar: UIProgressView!
    @IBOutlet weak var fourStarProgressBar: UIProgressView!
    @IBOutlet weak var fiveStarProgressBar: UIProgressView!

    @IBOutlet weak var topReviewsButton: FebysButton!
    @IBOutlet weak var mostRecentButton: FebysButton!
    @IBOutlet weak var seeMoreButton: FebysButton!

    @IBOutlet weak var usersReviewStackView: UIStackView!
    @IBOutlet weak var reviewsStackView: UIStackView!

    //MARK: Properties
    var tableViewRowsHeight: CGFloat = 0.0
    var product: Product?
    var stats: Stats?
    var ratingsAndReviews: [RatingsAndReviews]?
    var reviewScore: [Score]?
    var isMostRecent: Bool? = true { didSet{self.configureButton() }
    }
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureButton()
        self.setupButtonsActions()
    }
    
    //MARK: IBActions
    func setupButtonsActions() {
        self.mostRecentButton.didTap = { [weak self] in
            self?.isMostRecent = true
            self?.configure(self?.product)
        }
        
        self.topReviewsButton.didTap = { [weak self] in
            self?.isMostRecent = false
            self?.configure(self?.product)
        }
        
        self.seeMoreButton.didTap = { [weak self] in
            if let product = self?.product {
                self?.goToRatingAndReviewListing(product: product)
            }
        }
    }
    
    //MARK: Configure
    func configure(_ product: Product?){
        self.product = product
        self.stats = product?.stats
        self.reviewScore = product?.scores
        
        isMostRecent ?? true
        ? product?.byMostRecent()
        : product?.byRating()
        
        self.ratingsAndReviews = product?.ratingsAndReviews
        
        if let stats = self.stats,
            let scores = self.reviewScore {
            self.configureRatingStats(with: stats)
            self.configureRatingStars(with: scores)
        }
        
        if (self.ratingsAndReviews?.count == 0) {
            self.hideReviewsStackView(true)
        } else {
            self.hideReviewsStackView(false)
            if ((self.ratingsAndReviews?.count ?? 0) >= 3) {
                self.hideSeeMoreButton(false)
                configureStackView(with: self.ratingsAndReviews, isMore: true)
            } else {
                self.hideSeeMoreButton(true)
                configureStackView(with: self.ratingsAndReviews, isMore: false)

            }
        }
    }
    
    func configureButton() {
        if let isRecent = isMostRecent {
            self.setup(topReviewsButton, isSelected: isRecent ? false : true)
            self.setup(mostRecentButton, isSelected: isRecent ? true : false)
        }
    }
    
    func configureRatingStats(with stats: Stats) {
        let ratingString = "\(stats.rating?.score ?? 0) Based on \(stats.rating?.count ?? 0) ratings"
        self.avarageRatingLabel.text = ratingString
    }
    
    func configureRatingStars(with scores: [Score]) {
        var totalScore = 0
        _ = scores.compactMap { score in
            totalScore += (score.count ?? 0)
        }
        
        for score in scores {
            switch score.score {
            case 1:
                self.setupRating(oneStarProgressBar, label: oneStarCount, score: score, total: totalScore)
                break
            case 2:
                self.setupRating(twoStarProgressBar, label: twoStarCount, score: score, total: totalScore)
                break
            case 3:
                self.setupRating(threeStarProgressBar, label: threeStarCount, score: score, total: totalScore)
                break
            case 4:
                self.setupRating(fourStarProgressBar, label: fourStarCount, score: score, total: totalScore)
                break
            case 5:
                self.setupRating(fiveStarProgressBar, label: fiveStarCount, score: score, total: totalScore)
                break
            default:
                break
            }
        }
    }
    
    //MARK: Helper
    func setup(_ button: FebysButton, isSelected: Bool) {
        if isSelected {
            button.isSelected = true
            button.titleLabel?.font = .helvetica(type: .medium, size: 12)
            button.borderWidth = 0
            button.borderColor = .febysMildGreyColor()
            button.backgroundColor = .febysLightGray()
        } else {
            button.isSelected = false
            button.titleLabel?.font = .helvetica(type: .regular, size: 12)
            button.borderWidth = 1
            button.borderColor = .febysMildGreyColor()
            button.backgroundColor = .clear
        }
    }
    
    private func configureStackView(with ratingAndReviews: [RatingsAndReviews]?,
                                    isMore: Bool) {
        reviewsStackView.removeAllArrangedSubviews()
        if let reviews = ratingAndReviews {
            if isMore {
                for (index, review) in reviews.enumerated() {
                    if index < 3 {
                        addItem(in: reviewsStackView, with: review)
                    }
                }
            } else {
                for review in reviews {
                    addItem(in: reviewsStackView, with: review)
                }
            }
        }
    }
    
    private func addItem(in stackView: UIStackView, with review: RatingsAndReviews) {
        let reviewCell: RatingsAndReviewsCell = .fromNib()
        reviewCell.delegate = self
        reviewCell.selectionStyle = .none
        reviewCell.configure(review, isVotingEnabled: true)
        stackView.addArrangedSubview(reviewCell)
    }
    
    func setupRating(_ progressView: UIProgressView, label: FebysLabel, score: Score, total: Int) {
        let count = Float(score.count ?? 0)
        let progress = count / Float(total)
        progressView.progress = progress
        label.text = "\(score.count?.delimiter ?? "0")"
    }
    
    func hideReviewsStackView(_ isHidden: Bool) {
        if isHidden { self.usersReviewStackView.isHidden = true }
        else { self.usersReviewStackView.isHidden = false }
    }
    
    func hideSeeMoreButton(_ isHidden: Bool) {
        if isHidden { self.seeMoreButton.isHidden = true }
        else { self.seeMoreButton.isHidden = false }
    }
    
    //MARK: Navigation
    func goToRatingAndReviewListing(product: Product) {
        let vc = UIStoryboard.getVC(from: .Product, RatingAndReviewsViewController.className) as! RatingAndReviewsViewController
        vc.isMostRecent = self.isMostRecent ?? true
        vc.delegate = self
        vc.product = product
        vc.modalPresentationStyle = .fullScreen

        RedirectionManager.shared.presentOnRoot(vc, animated: true, completion: nil)
    }
    
    //MARK: API Calling
    func upVoteReviewBy(id: String, didRevoke: Bool) {
        ReviewVotingService.shared.upVote(reviewId: id, method: didRevoke ? .DELETE : .POST) { response in }
    }
    
    func downVoteReviewBy(id: String, didRevoke: Bool) {
        ReviewVotingService.shared.downVote(reviewId: id, method: didRevoke ? .DELETE : .POST) { response in }
    }
}

//MARK: RatingAndReviewDelegate
extension ReviewsViewCell: RatingAndReviewDelegate {
    func responseCallBack(ratingsAndReviews: [RatingsAndReviews]?) {
        self.product?.ratingsAndReviews = ratingsAndReviews
        self.configure(self.product)
    }
}

//MARK: ReviewsDelegate
extension ReviewsViewCell: ReviewDelegate {
    func didTapUpVote(reviewId: String?, isVoted: Bool?) {
        if let id = reviewId, let voted = isVoted {
            self.upVoteReviewBy(id: id, didRevoke: voted)
        }
    }
    
    func didTapDownVote(reviewId: String?, isVoted: Bool?) {
        if let id = reviewId, let voted = isVoted {
            self.downVoteReviewBy(id: id, didRevoke: voted)
        }
    }
}
