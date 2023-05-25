//
//  ReviewsHeaderViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 10/12/2021.
//

import UIKit

class ReviewsHeaderViewCell: UITableViewHeaderFooterView {
    
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
    @IBOutlet weak var averageRatingStack: UIStackView!
    @IBOutlet weak var ratingProgressStack: UIStackView!
    @IBOutlet weak var clientReviewsStack: UIStackView!
    
    //MARK: Properties
    var stats: Stats?
    var ratingsAndReviews: [RatingsAndReviews]?
    var reviewScore: [Score]?
    var isMostRecent: Bool? = true {didSet{self.configureButton()}}
    
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
        }
        
        self.topReviewsButton.didTap = { [weak self] in
            self?.isMostRecent = false
        }
    }
    
    //MARK: Configure
    func configure(_ product: Product?){
        self.stats = product?.stats
        self.reviewScore = product?.scores
        self.ratingsAndReviews = product?.ratingsAndReviews
        
        if let stats = self.stats,
           let scores = self.reviewScore {
            self.configureRatingStats(with: stats)
            self.configureRatingStars(with: scores)
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
    
    func setupRating(_ progressView: UIProgressView, label: FebysLabel, score: Score, total: Int) {
        let count = Float(score.count ?? 0)
        let progress = count / Float(total)
        progressView.progress = progress
        label.text = "\(score.count?.delimiter ?? "0")"
    }
}
