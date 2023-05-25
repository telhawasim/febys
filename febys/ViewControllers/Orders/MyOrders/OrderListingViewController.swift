//
//  MyOrdersViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 01/10/2021.
//

import UIKit

class OrderListingViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var navbarLabel: FebysLabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var pageNo = 1
    var chunkSize = 15
    var filters: [OrderStatus]?
    var orderType: OrderType?
    var ordersListing: OrderListing?
    var isLoading = true

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavLabel(for: orderType)
        configureTabelView()
        fetchOrderListing(isReturn: false)
    }
    
    //MARK: Navigation
    func goToOrderDetail(of id: String?, filters: [OrderStatus]?, type: OrderType?) {
        if let orderId = id, let filter = filters {
            let vc = UIStoryboard.getVC(from: .Orders, OrderDetailViewController.className) as! OrderDetailViewController
            vc.orderType = type
            vc.order_id = orderId
            vc.filters = filter
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: Helper
    func configureNavLabel(for orderType: OrderType?) {
        guard let orderType = orderType else { return }
        switch orderType {
        case .Order:
            self.navbarLabel.text = "My Orders"
            break
        case .Received:
            self.navbarLabel.text = "Received Orders"
            break
        case .Review:
            self.navbarLabel.text = "My Reviews"
            break
        case .Cancel:
            self.navbarLabel.text = "Cancelled Orders"
            break
        case .Return:
            self.navbarLabel.text = "Returned Orders"
            break
        }
    }
    
    func configureTabelView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                              bottom: 20, right: 0)
        tableView.register(OrderListingTableViewCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    //MARK: API Calling
    func fetchOrderListing(isReturn: Bool) {
        let params = [ParameterKeys.pageNo: pageNo,
                      ParameterKeys.chunkSize: chunkSize]
        
        var filterStrings = [String]()
        self.filters?.forEach({ eachOrderStatus in
            filterStrings.append(eachOrderStatus.rawValue)
        })
        
        let status = [ParameterKeys.dollarIN: filterStrings]
        
        var filters: [String:Any] = [:]
        switch orderType {
        case .Review:
            filters[ParameterKeys.has_reviewed] = true
        case .Return:
            filters[ParameterKeys.products_return_status] = status
        default:
            filters[ParameterKeys.products_status] = status
        }
        
        let bodyParams = [ParameterKeys.filters: filters]
        
        Loader.show()
        OrderService.shared.fetchOrderListing(body: bodyParams, params: params ) { response in
            Loader.dismiss()
            switch response {
            case .success(let orders):
                if self.ordersListing == nil{
                    self.ordersListing = orders.listing
                }else{
                    self.ordersListing?.orders?.append(contentsOf: orders.listing?.orders ?? [])
                }
                
                self.isLoading = false
                self.tableView.reloadData()
            case .failure(let error):
                self.isLoading = false
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: UITableView
extension OrderListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            if ordersListing?.orders?.count ?? 0 == 0 { return 1 }
            else {  return ordersListing?.orders?.count ?? 0 }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ordersListing?.orders?.count ?? 0 == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ordersListing?.orders?.count ?? 0 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenDescription)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderListingTableViewCell.className, for: indexPath) as! OrderListingTableViewCell
            
            cell.configure(ordersListing?.orders?[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((ordersListing?.orders?.count ?? 0) - 3) {
            if (pageNo + 1) <= ordersListing?.paginationInfo?.totalPages ?? 0 {
                pageNo += 1
                fetchOrderListing(isReturn: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ordersListing?.orders?.count ?? 0 == 0 {
            
        } else {
            self.goToOrderDetail(of: ordersListing?.orders?[indexPath.row].orderId, filters: self.filters, type: self.orderType)
        }
    }
}
