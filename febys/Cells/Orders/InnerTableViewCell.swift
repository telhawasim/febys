//
//  InnerTableViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 08/10/2021.
//

import UIKit

protocol InnerTableViewDelegate {
    func cancelOrder(of vendorId: String)
    func addReviews(of vendor: VendorProducts?)
    func didTapItem(at vendor: VendorProducts?)
    func didTapReturnItem(of vendor: VendorProducts?)
    func didTapVendorDetail(of vendorId: String)
}

class InnerTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: IntrinsicTableView!
    @IBOutlet weak var orderDetailButton: FebysButton!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var orderStepView: SteppedProgressBar!

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    var delegate: InnerTableViewDelegate?
    
    var rowHeights = [CGFloat]()
    var rowHeight: CGFloat = 0
    var headerHeight: CGFloat = 0
    var footerHeight: CGFloat = 0
    
    var returnProduct: Products?
    var vendor: VendorProducts?
    var orderStatus: OrderStatus?
    var orderType: OrderType?
    var isReturnOrder = false
    var isCancelable: Bool? {didSet{_ = self.getTableViewHeight()}}
    var isHeaderEnabled: Bool? {didSet{_ = self.getTableViewHeight()}}
    var isFooterEnabled: Bool? {didSet{_ = self.getTableViewHeight()}}
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
        orderDetailButton.didTap = { [weak self] in
            self?.delegate?.didTapItem(at: self?.vendor)
        }
    }

    //MARK: Configure
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 55
        tableView.estimatedSectionFooterHeight = 40

        tableView.register(ReviewsTableViewCell.className)
        tableView.register(OrderProductTableViewCell.className)
        tableView.registerHeaderFooter(ShoppingCartHeader.className)
        tableView.registerHeaderFooter(OrderDetailFooterView.className)
        tableView.registerHeaderFooter(VendorDetailFooterView.className)

    }
        
    func configureOrderStepView() {
        if let orderStatus = orderStatus,
           let timelineSteps = getTimelineSteps(status: orderStatus) {
            configureOrderTimeline(with: timelineSteps)
        } else {
            self.orderStepView.isHidden = true
        }
    }
    
    func configure(_ vendor: VendorProducts?, isCancelable: Bool?, isReturnOrder: Bool = false, isHeaderEnabled: Bool, isFooterEnabled: Bool) {
        self.orderStatus = OrderStatus(rawValue: vendor?.status ?? "")
        self.configureOrderStepView()
        self.vendor = vendor
        self.isReturnOrder = isReturnOrder
        self.isCancelable = isCancelable
        self.isHeaderEnabled = isHeaderEnabled
        self.isFooterEnabled = isFooterEnabled
        self.tableViewHeight.constant = getTableViewHeight()
        
        if orderType == .Review {
            didHideDetailButton(false)
        } else {
            didHideDetailButton(true)
        }
    }
    
    func getTimelineSteps(status: OrderStatus?) -> [OrderTimeline]? {
        if let status = status {
            var timelines = [OrderTimeline]()
            let isCancelled = [OrderStatus.CANCELED,
                               OrderStatus.CANCELLED_BY_VENDOR,
                               OrderStatus.REJECTED].contains(where: {$0 == status})
            
            timelines.append(
                OrderTimeline(title: status.isAccepted() ? "Confirmed" : "Pending",
                              isCompleted: status.isAccepted(),
                              isError: isCancelled)
            )
            
            if !isCancelled {
                timelines.append(
                    OrderTimeline(title: "On The Way",
                                  isCompleted: status.isShipped(),
                                  isError: isCancelled)
                )
            }
            
            timelines.append(
                OrderTimeline(title: isCancelled ? "Canceled" : "Received",
                              isCompleted: isCancelled || status.isReceived(),
                              isError: isCancelled)
            )
            
            return timelines
            
        } else {
            self.orderStepView.isHidden = true
            return nil
        }
    }
    
    func configureOrderTimeline(with timeline: [OrderTimeline]) {
        let lastCompletedIndex = (timeline.lastIndex(where: {$0.isCompleted == true}) ?? 0) + 1
        var activeColor: UIColor = .greenTimeline()
        var titles = [String]()
       
        timeline.forEach {
            item in titles.append(item.title)
            if item.isError {activeColor = .redTimeline()}
        }
        
        self.orderStepView.currentTab = lastCompletedIndex
        self.orderStepView.activeColor = activeColor
        self.orderStepView.titles = titles
        self.orderStepView.stepDrawingMode = .stroke
        self.orderStepView.insets = UIEdgeInsets(top:0,left:20,bottom:0,right:20)
    }
    
    //MARK: Helper
    func didHideDetailButton(_ isHidden: Bool) {
        isHidden
        ? (self.orderDetailButton.isHidden = true)
        : (self.orderDetailButton.isHidden = false)
    }
    
    func getTableViewHeight() -> CGFloat{
        tableView.layoutIfNeeded()
        tableView.reloadData()
        
//        var rowsHeight: CGFloat = 0
//        _ = self.rowHeights.compactMap { height in
//            rowsHeight += height
//            print("Height: ", height)
//        }
        
        let productCount = vendor?.products?.count ?? 0
        return headerHeight + (CGFloat(productCount) * rowHeight) + footerHeight

        
//        return headerHeight + rowsHeight + footerHeight
    }
}

//MARK: UITableView
extension InnerTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendor?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isHeaderEnabled ?? false {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShoppingCartHeader.className) as! ShoppingCartHeader
            
            view.trailingConstraint.constant = 12.0
            view.leadingConstraint.constant = 12.0
            view.configure(with: vendor?.vendor, forCart: false,
                           status: vendor?.status ?? "",
                           isCancelable: self.isCancelable ?? false)
            
            view.cancelButton.didTap = { [weak self] in
                self?.delegate?.cancelOrder(of: self?.vendor?.vendor?.id ?? "")
            }
            
            view.vendorDetailButton.didTap = {[weak self] in
                self?.delegate?.didTapVendorDetail(of: self?.vendor?.vendor?.id ?? "")
            }
            
            self.headerHeight = view.contentView.bounds.height
            return view
    
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isFooterEnabled ?? false {
            if isReturnOrder {
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: VendorDetailFooterView.className) as! VendorDetailFooterView
                view.configure(vendor?.vendor)
                self.footerHeight = view.mainStackView.bounds.height
                return view
            } else {
                let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderDetailFooterView.className) as! OrderDetailFooterView
                view.configure(vendor, isRefundable: vendor?.isRefundable() ?? false)
                self.footerHeight = view.mainStackView.bounds.height
                view.addReviewButton.didTap = { [weak self] in
                    self?.delegate?.addReviews(of: self?.vendor)
                }
                
                view.returnItemButton.didTap = { [weak self] in
                    if let product = self?.returnProduct {
                        var vendor = self?.vendor
                        vendor?.products?.removeAll()
                        vendor?.products?.append(product)
                        self?.delegate?.didTapReturnItem(of: vendor)
                    }
                }
                return view
            }
        }
        return nil 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch orderType {
        case .Review:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReviewsTableViewCell.className, for: indexPath) as! ReviewsTableViewCell
            let item = vendor?.products
            
            if !(isFooterEnabled ?? true) {
                (indexPath.row == ((item?.count ?? 0) - 1))
                ? cell.didHideDivider(true)
                : cell.didHideDivider(false)
            } else { cell.didHideDivider(false) }

            cell.mainStackView.layoutIfNeeded()
            cell.configure(item?[indexPath.row])
            
            self.rowHeight = cell.mainStackView.bounds.height
//            self.rowHeights[indexPath.row] =  cell.mainStackView.bounds.height
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderProductTableViewCell.className, for: indexPath) as! OrderProductTableViewCell
            
            let item = vendor?.products
            
            (indexPath.row == ((item?.count ?? 0) - 1))
            ? cell.didHideDivider(true)
            : cell.didHideDivider(false)
            
            var isSelectable = false
            if orderStatus == .DELIVERED {
                isSelectable = item?[indexPath.row].refundable ?? false
                if isReturnOrder { isSelectable = false }
            }
            
            cell.configure(with: item?[indexPath.row], isSelectable: isSelectable, returnDetail: vendor?.returnDetails?.first)
            
            cell.selectProductButton.didTap = { [weak self] in
                let isSelected = item?[indexPath.row].isSelected ?? false
                
                if isSelected {
                    self?.vendor?.products?[indexPath.row].isSelected = !isSelected
                } else {
                    _ = self?.vendor?.products?.enumerated().compactMap({ (index, _) in
                        self?.vendor?.products?[index].isSelected = false
                    })
                    self?.vendor?.products?[indexPath.row].isSelected = !(isSelected)
                }
                self?.returnProduct = item?[indexPath.row]
                self?.tableView.reloadData()
            }
            
            self.rowHeight = cell.mainStackView.bounds.height

//            self.rowHeights.append(cell.mainStackView.bounds.height)
            return cell
        }
    }
}
