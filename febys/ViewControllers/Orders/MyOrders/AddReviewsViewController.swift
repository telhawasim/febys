//
//  AddReviewsViewController.swift
//  febys
//
//  Created by Nouman Akram on 21/12/2021.
//

import UIKit

protocol AddReviewsDelegate {
    func hasReviewed(_ hasReviewed: Bool, with data: RatingAndReviewResponse, of vendorProductId: String)
}

class AddReviewsViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var navbarTitleLabel: FebysLabel!
    @IBOutlet weak var editReviewButton: FebysButton!
    @IBOutlet weak var addReviewButton: FebysButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variable
    var isEditable = false
    var isReviewEditing = false
    var orderId: String?
    var delegate: AddReviewsDelegate?
    var vendorProduct: VendorProducts?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar(with: isEditable)
        self.configureEditReviewButton(isEditing: isReviewEditing)
        self.createDefaultRatingsAndReviews()
        self.configureTableView()
        self.setupButtonAction()

        if vendorProduct?.hasReviewed ?? false {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    func createDefaultRatingsAndReviews() {
        self.vendorProduct?.products?.enumerated().forEach({ (index, product) in
            let productReview = RatingsAndReviews()
            productReview.id = product.ratingAndReview?.id
            productReview.consumerId = product.ratingAndReview?.consumerId
            productReview.orderId = product.ratingAndReview?.orderId ?? self.orderId
            productReview.productId = product.ratingAndReview?.productId ?? product.product?.id
            productReview.skuId = product.ratingAndReview?.skuId ?? product.product?.variants?.first?.skuId
            productReview.upVotes = product.ratingAndReview?.upVotes
            productReview.downVotes = product.ratingAndReview?.downVotes
            productReview.review = product.ratingAndReview?.review ?? Review()
            productReview.score = product.ratingAndReview?.score ?? 5.0
            productReview.createdAt = product.ratingAndReview?.createdAt
            productReview.updatedAt = product.ratingAndReview?.updatedAt
            self.vendorProduct?.products?[index].ratingAndReview = productReview
        })
        
        let vendor = self.vendorProduct?.ratingAndReview
        let vendorReview = RatingsAndReviews()
        vendorReview.id = vendor?.id
        vendorReview.consumerId = vendor?.consumerId
        vendorReview.consumer = vendor?.consumer
        vendorReview.orderId = vendor?.orderId ?? self.orderId
        vendorReview.vendorId = vendor?.orderId ?? self.vendorProduct?.vendor?.id
        vendorReview.valueScore = vendor?.valueScore ?? 5.0
        vendorReview.pricingScore = vendor?.pricingScore ?? 5.0
        vendorReview.qualityScore = vendor?.qualityScore ?? 5.0
        vendorReview.review = vendor?.review ?? Review()
        vendorReview.createdAt = vendor?.createdAt
        vendorReview.updatedAt = vendor?.updatedAt
        self.vendorProduct?.ratingAndReview = vendorReview
    }
    
    //MARK: Helpers
    func setupButtonAction() {
        self.editReviewButton.didTap = { [weak self] in
            guard let self = self else {return}
            self.isReviewEditing = !(self.isReviewEditing)
            self.configureEditReviewButton(isEditing: self.isReviewEditing)
            self.tableView.reloadData()
            if !(self.isReviewEditing) {
                self.addProductRatingAndReviewBy(id: self.orderId ?? "")
            }
        }
        
        self.addReviewButton.didTap = { [weak self] in
            self?.addProductRatingAndReviewBy(id: self?.orderId ?? "")
        }
    }
    
    func configureEditReviewButton(isEditing: Bool) {
        self.navbarTitleLabel.text = isEditing ? "Edit Review" :  "My Review"
        self.editReviewButton.isSelected = isEditing ? true : false
    }
    
    func configureNavBar(with isEditable: Bool) {
        self.editReviewButton.isHidden = isEditable ? false : true
        self.addReviewButton.isHidden = isEditable ? true : false
        self.navbarTitleLabel.text = "Add Review"
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        tableView.registerHeaderFooter(ShoppingCartHeader.className)
        tableView.register(SellerFeedbackTableViewCell.className)
        tableView.register(ProductRatingTableViewCell.className)
    }
    
    //MARK: API Calling
    func addProductRatingAndReviewBy(id: String) {
        let hasReviewed = self.vendorProduct?.hasReviewed ?? false
        var reviewsDictionary = [[String:Any]]()
        _ = self.vendorProduct?.products?.compactMap({ product in
            let comment = [ParameterKeys.comment: product.ratingAndReview?.review?.comment ?? ""]
            var newReview = [ParameterKeys.sku_id: product.ratingAndReview?.skuId ?? "",
                             ParameterKeys.score: product.ratingAndReview?.score ?? 5.0,
                             ParameterKeys.review: comment] as [String : Any]
            if hasReviewed { newReview[ParameterKeys.id] = product.ratingAndReview?.id }
            reviewsDictionary.append(newReview)
        })
        
        let comment = [ParameterKeys.comment: self.vendorProduct?.ratingAndReview?.review?.comment ?? ""]
        var vendorRating = [ ParameterKeys.vendor_id:
                                self.vendorProduct?.vendor?.id ?? "",
                             ParameterKeys.pricing_score:
                                self.vendorProduct?.ratingAndReview?.pricingScore ?? 5.0,
                             ParameterKeys.value_score:
                                self.vendorProduct?.ratingAndReview?.valueScore ?? 5.0,
                             ParameterKeys.quality_score:
                                self.vendorProduct?.ratingAndReview?.qualityScore ?? 5.0,
                             ParameterKeys.review: comment] as [String : Any]
        if hasReviewed { vendorRating[ParameterKeys.id] = self.vendorProduct?.ratingAndReview?.id }
        
        let bodyParams = [ParameterKeys.products_ratings: reviewsDictionary,
                          ParameterKeys.vendor_rating: vendorRating] as [String : Any]
        
        Loader.show()
        ReviewsService.shared.addProductRatingAndReview(id: id, body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let ratingsAndReviews):
                self.delegate?.hasReviewed(true, with: ratingsAndReviews, of: self.vendorProduct?.id ?? "")
                self.showMessage(Constants.thankYou,
                                 self.isEditable
                                 ? Constants.reviewUpdatedSuccessfully
                                 : Constants.reviewAddedSuccessfully,
                                 messageImage: .success) {
                    self.backButtonTapped(self)
                }
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: ProductRatingDelegate
extension AddReviewsViewController: ProductRatingDelegate {
    func addProductReview(of skuId: String, rating: Double, comment: String ) {
        self.vendorProduct?.products?.enumerated().forEach({ (i, product) in
            if product.product?.variants?.first?.skuId == skuId {
                self.vendorProduct?.products?[i].ratingAndReview?.skuId = skuId
                self.vendorProduct?.products?[i].ratingAndReview?.score = rating
                self.vendorProduct?.products?[i].ratingAndReview?.review?.comment = comment
            }
        })
    }
}

//MARK: SellerFeedbackDelegate
extension AddReviewsViewController: SellerFeedbackDelegate {
    func addVendorReview(priceRating: Double, valueRating: Double, qualityRating: Double, comment: String) {
        self.vendorProduct?.ratingAndReview?.pricingScore = priceRating
        self.vendorProduct?.ratingAndReview?.valueScore = valueRating
        self.vendorProduct?.ratingAndReview?.qualityScore = qualityRating
        self.vendorProduct?.ratingAndReview?.review?.comment = comment
    }
}

//MARK: TableView Methods
extension AddReviewsViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.vendorProduct?.products?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShoppingCartHeader.className) as! ShoppingCartHeader
        header.configure(with: vendorProduct?.vendor, forCart: false)
        header.leadingPadding.constant = 21.0
        header.trailingPadding.constant = 21.0
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: SellerFeedbackTableViewCell.className, for: indexPath) as! SellerFeedbackTableViewCell
            cell.delegate = self
            cell.configure(self.vendorProduct?.ratingAndReview,
                           hasReviewed: self.isEditable ? (vendorProduct?.hasReviewed) : false,
                           isEdititng: self.isReviewEditing)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductRatingTableViewCell.className, for: indexPath) as! ProductRatingTableViewCell
            cell.delegate = self
            cell.configure(self.vendorProduct?.products?[indexPath.row],
                           hasReviewed: self.isEditable ? (vendorProduct?.hasReviewed) : false,
                           isEditing: self.isReviewEditing)
            return cell
            
        }
    }
}
