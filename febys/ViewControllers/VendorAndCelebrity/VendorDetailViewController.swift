//
//  VendorstoreDetaillViewController.swift
//  febys
//
//  Created by Nouman Akram on 14/12/2021.
//

import UIKit

class VendorDetailViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vendorStoreHeaderLabel: FebysLabel!
    @IBOutlet weak var officialBadgeImage: UIImageView!
    
    //MARK: Variable
    var vendorId: String?
    var vendorDetails: Vendor?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = vendorId { self.fetchVendorStoreDetailsBy(id: id) }
        self.tableViewSetup()
    
    }
    
    //MARK: Register Cell
    func tableViewSetup(){
//        if #available(iOS 15.0, *) {
//            UITableView.appearance().sectionHeaderTopPadding = 0
//        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                              bottom: 40, right: 0)
        
        tableView.register(VendorDetailTableViewCell.className)
        tableView.register(RatingsAndReviewsCell.className)
        tableView.register(ReviewHeaderTableViewCell.className)
    }
    
    //MARK: Api Callings
    func fetchVendorStoreDetailsBy(id: String){
        Loader.show()
        CelebrityService.shared.getCelebrityDetails(id: id) { response in
            Loader.dismiss()
            switch response{
            case .success(let vendorDetails):
                self.vendorDetails = vendorDetails
                self.vendorStoreHeaderLabel.text = vendorDetails.shopName ?? ""
                if let isOfficial = vendorDetails.official {
                    self.officialBadgeImage.isHidden = isOfficial ? false : true
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: TableView Methods
extension VendorDetailViewController: UITableViewDelegate , UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = vendorDetails?.ratingsAndReviews?.count ?? 0
        (count > 0) ? (count += 2) : (count = 1)
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VendorDetailTableViewCell.className, for: indexPath) as! VendorDetailTableViewCell
            cell.configure(self.vendorDetails, forVendor: true)
            
            cell.followButton.didTap = { [weak self] in
                guard let self = self else { return }
                if cell.followButton.isSelected {
                    self.showMessage(Constants.areYouSure, Constants.youWantToUnfollowVendor, messageImage: .follow, isQuestioning: true, onSuccess:{
                        FollowingListManager.shared.followOrUnfollowVendor(cell.followButton, by: self.vendorDetails?.id ?? "")
                    }, onDismiss: nil)
                } else {
                    FollowingListManager.shared.followOrUnfollowVendor(cell.followButton, by: self.vendorDetails?.id ?? "")
                }
            }
            
            return cell
            
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewHeaderTableViewCell.className, for: indexPath) as! ReviewHeaderTableViewCell
            cell.configure(vendorDetails)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingsAndReviewsCell.className, for: indexPath) as! RatingsAndReviewsCell
            vendorDetails?.byMostRecent()
            cell.selectionStyle = .none
            cell.userRating.isHidden = true
            cell.leadingConstraint.constant = 21.0
            cell.trailingConstraint.constant = 21.0
            cell.configure(vendorDetails?.ratingsAndReviews?[indexPath.row - 2], isVotingEnabled: false)
            return cell
        }
    }
}

