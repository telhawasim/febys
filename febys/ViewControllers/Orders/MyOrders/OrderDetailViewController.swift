//
//  OrderDetailViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 07/10/2021.
//

import UIKit
import XLPagerTabStrip


class OrderDetailViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var navbarLabel: FebysLabel!
    @IBOutlet weak var navbarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    var indexPath: IndexPath?
    var itemInfo: IndicatorInfo = ""
    var order_id: String?
    var filters: [OrderStatus]?
    var orderType: OrderType?
    var order: Order?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = order_id { self.fetchOrderBy(id: id) }
        
        self.configureNavLabel(for: orderType)
        self.configureTableView()
    }
    
    //MARK: Helper
    func configureNavLabel(for orderType: OrderType?) {
        guard let orderType = orderType else { return }
        switch orderType {
        case .Order:
            self.navbarLabel.text = "Order Details"
            break
        case .Received:
            self.navbarLabel.text = "Received Details"
            break
        case .Review:
            self.navbarLabel.text = "My Review"
            break
        case .Cancel:
            self.navbarLabel.text = "Cancellation Details"
            break
        case .Return:
            self.navbarLabel.text = "Return Details"
            break
        }
    }
    
    func isHeaderEnabled(_ orderType: OrderType?) -> Bool {
        guard let orderType = orderType else { return false}
        switch orderType {
        default :
            return true
        }
    }
    
    func isFooterEnabled(_ orderType: OrderType?) -> Bool {
        guard let orderType = orderType else { return false}
        switch orderType {
        case .Review, .Return:
            return false
        default :
            return true
        }
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(InnerTableViewCell.className)
        tableView.register(SummaryDetailViewCell.className)
        tableView.registerHeaderFooter(OrderDetailHeaderView.className)
    }
    
    func filterOrder(_ order: Order?, for status: [OrderStatus]?) {
        if let order = order {
            for vendorProducts in (order.vendorProducts ?? []){
                let orderStatus = OrderStatus(rawValue:vendorProducts.status ?? "")
                if ((status?.contains(orderStatus ?? .PENDING)) != nil) {
                    
                }
            }
        }
    }
    
    //MARK: Navigation
    func goToAddProductsReview(of vendor: VendorProducts, isEditable: Bool) {
        let vc = UIStoryboard.getVC(from: .Orders, AddReviewsViewController.className) as! AddReviewsViewController
        vc.delegate = self
        vc.orderId = self.order?.orderId
        vc.vendorProduct = vendor
        vc.isEditable = isEditable
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToVendorDetail(of vendorId: String?) {
        let vc = UIStoryboard.getVC(from: .VendorStore, VendorDetailViewController.className) as! VendorDetailViewController
        vc.vendorId = vendorId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentCancelBottomSheet(orderId: String, vendorId: String){
        let vc = UIStoryboard.getVC(from: .Orders, CancelOrderBottomSheetController.className) as! CancelOrderBottomSheetController
        vc.delegate = self
        vc.orderId = orderId
        vc.vendorId = vendorId
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        RedirectionManager.shared.presentOnRoot(vc, animated: true, completion: nil)
    }
    
    func goToReturnProduct(of vendor: VendorProducts, orderId: String) {
        let vc = UIStoryboard.getVC(from: .Orders, ReturnOrderViewController.className) as! ReturnOrderViewController
        vc.delegate = self
        vc.orderId = orderId
        vc.vendor = vendor
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: API Calling
    func fetchOrderBy(id: String?) {
        var filterStrings = [String]()
        self.filters?.forEach({ eachOrderStatus in
            filterStrings.append(eachOrderStatus.rawValue)
        })
        
        let status = [ParameterKeys.dollarIN: filterStrings]
        let filters = [ParameterKeys.products_status: status]
        let bodyParams = [ParameterKeys.filters: filters] //Order Filters
        
        Loader.show()
        OrderService.shared.fetchOrderBy(id: id ?? "") {
            response in
            Loader.dismiss()
            switch response {
            case .success(let order):
                self.order = order.order
                if self.orderType == .Review {
                    _ = self.order?.vendorProducts?.enumerated().compactMap({(i, v) in
                        if !(v.hasReviewed ?? false) {
                            self.order?.vendorProducts?.remove(at: i)
                        }
                    })
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: ReturnOrderDelegate
extension OrderDetailViewController: ReturnOrderDelegate {
    func didOrderReturned() {
        self.fetchOrderBy(id: self.order_id)
    }
}

//MARK: AddReviewsDelegate
extension OrderDetailViewController: AddReviewsDelegate {
    func hasReviewed(_ hasReviewed: Bool, with data: RatingAndReviewResponse, of vendorProductId: String) {
        guard let index = self.order?.vendorProducts?.firstIndex(where: { $0.id == vendorProductId }) else { return }
        self.order?.vendorProducts?[index].hasReviewed = hasReviewed
        self.order?.vendorProducts?[index].ratingAndReview = data.vendorRating
        self.order?.vendorProducts?[index].products?.enumerated().forEach({ (i, _) in
            self.order?.vendorProducts?[index].products?[i].ratingAndReview = data.productsRatings?[i]
        })
        
        self.tableView.reloadData()
    }
}

//MARK: InnerTableViewDelegate
extension OrderDetailViewController: InnerTableViewDelegate {
    func didTapReturnItem(of vendor: VendorProducts?) {
        if let vendor = vendor {
            self.goToReturnProduct(of: vendor, orderId: self.order_id ?? "")
        }
    }
    
    func didTapItem(at vendor: VendorProducts?) {
        if let vendor = vendor {
            self.goToAddProductsReview(of: vendor, isEditable: true)
        }
    }
    
    func addReviews(of vendor: VendorProducts?) {
        if let vendor = vendor { self.goToAddProductsReview(of: vendor, isEditable: false) }
    }
    
    func cancelOrder(of vendorId: String) {
        self.presentCancelBottomSheet(orderId: self.order?.orderId ?? "", vendorId: vendorId)
    }
    
    func didTapVendorDetail(of vendorId: String) {
            self.goToVendorDetail(of: vendorId)
        }
    }


//MARK: PickerViewDelegate
extension OrderDetailViewController: PickerViewDelegate {
    func dismissPicker() {
        if let id = order_id { self.fetchOrderBy(id: id) }
    }
}

//MARK: UITableView
extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 50
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.order?.vendorProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderDetailHeaderView.className) as! OrderDetailHeaderView
        headerView.configure(order)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch orderType {
        case .Review, .Return :
            return nil
        default:
            let footer = tableView.dequeueReusableCell(withIdentifier: SummaryDetailViewCell.className) as! SummaryDetailViewCell
            footer.configure(self.order)
            return footer
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.indexPath = indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: InnerTableViewCell.className, for: indexPath) as! InnerTableViewCell
        cell.delegate = self
        cell.orderType = self.orderType
        cell.topConstraint.constant = 10
        cell.bottomConstraint.constant = 10
        
        cell.configure(self.order?.vendorProducts?[indexPath.row],
                       isCancelable: self.order?.isOrderCancelable(),
                       isHeaderEnabled: self.isHeaderEnabled(self.orderType),
                       isFooterEnabled: self.isFooterEnabled(self.orderType))
        
        return cell
    }
}


//MARK: PAGER TAB DELEGATE
extension OrderDetailViewController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
}
