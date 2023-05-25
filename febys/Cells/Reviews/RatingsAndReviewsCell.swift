//
//  ReviewTableViewCell.swift
//  febys
//
//  Created by Abdul Kareem on 28/09/2021.
//

import UIKit
import Cosmos

protocol ReviewDelegate {
    func didTapUpVote(reviewId: String?, isVoted: Bool?)
    func didTapDownVote(reviewId: String?, isVoted: Bool?)
}

class RatingsAndReviewsCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: FebysLabel!
    @IBOutlet weak var userRating: CosmosView!
    @IBOutlet weak var userReviewCommentLabel: FebysLabel!
    @IBOutlet weak var reviewDateLabel: FebysLabel!
    @IBOutlet weak var upVoteButton: FebysButton!
    @IBOutlet weak var downVoteButton: FebysButton!
    @IBOutlet weak var priceRatingLabel: FebysLabel!
    @IBOutlet weak var valueRatingLabel: FebysLabel!
    @IBOutlet weak var qualityRatingLabel: FebysLabel!
    @IBOutlet weak var votesStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var userRatingsView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    
    //MARK: Properties
    var upVotes = 0
    var downVotes = 0
    var consumerId: String?
    var delegate: ReviewDelegate?
    var ratingAndReview: RatingsAndReviews?
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        if let id = UserInfo.fetch()?.consumerInfo?.id {
            self.consumerId = "\(id)"
        }
        
        self.setupButtonAction()
    }
    
    //MARK: IBActions
    func setupButtonAction() {
        self.upVoteButton.didTap = { [weak self] in
            if User.fetch() != nil {
                self?.delegate?.didTapUpVote(reviewId: self?.ratingAndReview?.id,
                                             isVoted: self!.isUpVoted())
                
                self?.updateVoteCount(self!.upVoteButton,
                                      isVoted: self!.isUpVoted(),
                                      count: &self!.upVotes,
                                      votes: &(self!.ratingAndReview!.upVotes)!)
                
                if self!.isDownVoted() {
                    self?.updateVoteCount(self!.downVoteButton,
                                          isVoted: self!.isDownVoted(),
                                          count: &self!.downVotes,
                                          votes: &(self!.ratingAndReview!.downVotes)!)
                }
                
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
        
        self.downVoteButton.didTap = { [weak self] in
            if User.fetch() != nil {
                self?.delegate?.didTapDownVote(reviewId: self?.ratingAndReview?.id,
                                               isVoted: self!.isDownVoted())

                self?.updateVoteCount(self!.downVoteButton,
                                      isVoted: self!.isDownVoted(),
                                      count: &self!.downVotes,
                                      votes: &(self!.ratingAndReview!.downVotes)!)

                if self!.isUpVoted() {
                    self?.updateVoteCount(self!.upVoteButton,
                                          isVoted: self!.isUpVoted(),
                                          count: &self!.upVotes,
                                          votes: &(self!.ratingAndReview!.upVotes)!)
                }
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
    }
    
    
    //MARK: Helper
    private func isUpVoted() -> Bool {
        if let upVotes = self.ratingAndReview?.upVotes {
            if upVotes.contains(self.consumerId ?? "") { return true }
            else { return false }
        }
        return false
    }
    
    private func isDownVoted() -> Bool {
        if let downVotes = self.ratingAndReview?.downVotes {
            if downVotes.contains(self.consumerId ?? "") { return true }
            else { return false }
        }
        return false
    }
    
    private func updateVoteCount(_ button: FebysButton, isVoted: Bool, count: inout Int, votes: inout [String]) {
        if isVoted {
            if let i = votes.firstIndex(of: consumerId ?? "") {
                button.isSelected = false
                votes.remove(at: i)
                (count > 0) ? (count -= 1) : (count = 0)
            }
        } else {
            button.isSelected = true
            votes.append(consumerId ?? "")
            count += 1
        }
        self.setVoteCountOf(button, with: count)

    }
    
    private func setVoteCountOf(_ button: FebysButton, with count: Int) {
        button.setTitle("\(count)", for: .normal)
        button.setTitle("\(count)", for: .selected)
    }
    
    func didHideVoteStackView(_ isHidden: Bool) {
        isHidden
        ? (self.votesStackView.isHidden = true)
        : (self.votesStackView.isHidden = false)
    }
    
    func didHideUserRatingsStackView(_ isHidden: Bool) {
        isHidden
        ? (self.userRatingsView.isHidden = true)
        : (self.userRatingsView.isHidden = false)
    }
    
    func hideUserComment(_ isHidden: Bool) {
        if isHidden { self.userReviewCommentLabel.isHidden = true }
        else { self.userReviewCommentLabel.isHidden = false }
    }
        
    //MARK: Configure
    func configure(_ ratingAndReview: RatingsAndReviews?, isVotingEnabled: Bool) {
        self.ratingAndReview = ratingAndReview
        
        if isVotingEnabled {
            self.didHideVoteStackView(false)
            self.didHideUserRatingsStackView(true)
            self.userRating.rating = Double(ratingAndReview?.score ?? 0)
        } else {
            self.didHideVoteStackView(true)
            self.didHideUserRatingsStackView(false)
            
            let pricingScore = Int(ratingAndReview?.pricingScore ?? 0.0)
            let valueScore = Int(ratingAndReview?.valueScore ?? 0.0)
            let qualityScore = Int(ratingAndReview?.qualityScore ?? 0.0)
            
            priceRatingLabel.text = "\(pricingScore)"
            valueRatingLabel.text = "\(valueScore)"
            qualityRatingLabel.text = "\(qualityScore)"

        }
        
        let userName = "\(ratingAndReview?.consumer?.first_name?.trim() ?? "") \(ratingAndReview?.consumer?.last_name?.trim() ?? "")"
        
        self.userNameLabel.text = userName
        if let url = ratingAndReview?.consumer?.profile_image {
            self.userImage.setImage(url: url)
        } else {
            self.userImage.image = UIImage(named: "user.png")
        }
        
        if let comment = ratingAndReview?.review?.comment {
            if comment != "" {
                self.hideUserComment(false)
                self.userReviewCommentLabel.text = comment
                self.userReviewCommentLabel.sizeToFit()
            } else {
                self.hideUserComment(true)
            }
        }
        
        if let date = ratingAndReview?.createdAt {
            self.reviewDateLabel.text = Date.getFormattedDate(string: date, format: Constants.dateFormatDD_MMM_yyyy)
        }
        
        
        self.upVotes = ratingAndReview?.upVotes?.count ?? 0
        self.downVotes = ratingAndReview?.downVotes?.count ?? 0
        
        self.upVoteButton.isSelected = isUpVoted()
        self.downVoteButton.isSelected = isDownVoted()
        
        self.setVoteCountOf(upVoteButton, with: upVotes)
        self.setVoteCountOf(downVoteButton, with: downVotes)
        
        self.mainStackView.layoutIfNeeded()
    }
    
    
}
