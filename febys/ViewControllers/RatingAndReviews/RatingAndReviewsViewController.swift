//
//  RatingAndReviewsViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 09/12/2021.
//

import UIKit

protocol RatingAndReviewDelegate {
    func responseCallBack(ratingsAndReviews: [RatingsAndReviews]?)
}

class RatingAndReviewsViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var crossButton: FebysButton!
    
    //MARK: Properties
    var delegate: RatingAndReviewDelegate?
    var product: Product?
    var isMostRecent: Bool = false {didSet{self.sortRatingAndReviews()}}
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortRatingAndReviews()
        self.configureTableView()
        
        self.crossButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.delegate?.responseCallBack(ratingsAndReviews: self.product?.ratingsAndReviews)
            self.backButtonTapped(self.crossButton!)
        }
    }
    
    //MARK: Helpers
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.registerHeaderFooter(ReviewsHeaderViewCell.className)
        tableView.register(RatingsAndReviewsCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    func sortRatingAndReviews() {
        isMostRecent
        ? product?.byMostRecent()
        : product?.byRating()
    }
    
    //MARK: API Calling
    func upVoteReviewBy(id: String, didRevoke: Bool) {
        ReviewVotingService.shared.upVote(reviewId: id, method: didRevoke ? .DELETE : .POST) { response in }
    }
    
    func downVoteReviewBy(id: String, didRevoke: Bool) {
        ReviewVotingService.shared.downVote(reviewId: id, method: didRevoke ? .DELETE : .POST) { response in }
    }
}

//MARK: ReviewDelegate
extension RatingAndReviewsViewController: ReviewDelegate {
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

//MARK: UITableView
extension RatingAndReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if product?.ratingsAndReviews?.count ?? 0 == 0{ return 1 }else{
            return product?.ratingsAndReviews?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if product?.ratingsAndReviews?.count ?? 0 == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewsHeaderViewCell.className) as! ReviewsHeaderViewCell
        header.configure(self.product)
        header.isMostRecent = self.isMostRecent
        header.mostRecentButton.didTap = { [weak self] in
            self?.isMostRecent = true
            self?.tableView.reloadData()
        }
        
        header.topReviewsButton.didTap = { [weak self] in
            self?.isMostRecent = false
            self?.tableView.reloadData()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if product?.ratingsAndReviews?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenStoresDescription)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingsAndReviewsCell.className, for: indexPath) as! RatingsAndReviewsCell
            cell.delegate = self
            cell.leadingConstraint.constant = 21
            cell.trailingConstraint.constant = 21
            cell.configure(self.product?.ratingsAndReviews?[indexPath.row], isVotingEnabled: true)
            return cell
        }
    }
}

