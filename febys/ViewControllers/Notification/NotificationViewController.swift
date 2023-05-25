//
//  NotificationViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 10/02/2022.
//

import UIKit

class NotificationViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signInButton: FebysButton!
    
    //MARK: Properties
    var totalRows = 0
    var pageNo = 1
    var pageSize = 15
    var notifications: NotificationResponse?
    var isLoading = true

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationUpdated), name: .notificationUpdated, object: nil)
        
        if UserInfo.fetch() != nil {
            tableView.isHidden = false
            loginView.isHidden = true
            fetchNotification()
        } else {
            tableView.isHidden = true
            loginView.isHidden = false
        }
        
        signInButton.didTap = {
            RedirectionManager.shared.goToLogin(redirectToHome: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserInfo.fetch() != nil {
            UIApplication.shared.applicationIconBadgeNumber = 0
            RedirectionManager.shared.addOrRemoveNotificationBadge()
            NotificationService.shared.updateNotificationBadge()
        }
    }
    
    //MARK: Helpers
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(NotificationTableViewCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    func getOrderTypeBy(status: OrderStatus) -> OrderType {
        switch status {
        case .PENDING, .ACCEPTED, .SHIPPED:
            return .Order
        case .CANCELED, .CANCELLED_BY_VENDOR, .REJECTED:
            return .Cancel
        case .RETURNED, .PENDING_RETURN:
            return .Return
        case .DELIVERED:
            return .Received
        }
    }
    
    //MARK: Navigation
    func goToFebysPlus(){
        let vc = UIStoryboard.getVC(from: .FebysPlus, FebysPlusViewController.className) as! FebysPlusViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProfileSettings(){
        let vc = UIStoryboard.getVC(from: .Account, ProfileSettingViewController.className) as! ProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToProductDetail(_ productId: String, threadId: String){
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.productId = productId
        vc.threadId = threadId
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToOrderDetail(of id: String?, filters: [OrderStatus]?, type: OrderType?) {
        if let orderId = id, let filter = filters {
            let vc = UIStoryboard.getVC(from: .Orders, OrderDetailViewController.className) as! OrderDetailViewController
            vc.orderType = type
            vc.order_id = orderId
            vc.filters = filter
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateNotificationStatus(at indexPath: IndexPath) {
        let id = self.notifications?.listing?.notifications?[indexPath.row].id
        self.notifications?.listing?.notifications?[indexPath.row].read = true
        self.tableView.reloadRows(at: [indexPath], with: .none)
        NotificationService.shared.updateNotificationStatus(of: id ?? "")
    }
    
    //MARK: API Calling
    @objc func notificationUpdated() {
        pageNo = 1
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.fetchNotification(isSilent: true)
        }
    }
    
    func fetchNotification(isSilent: Bool = false) {
        let params = [ParameterKeys.chunkSize: pageSize,
                      ParameterKeys.pageNo: pageNo] as [String : Any]
        
        let sorter = [ParameterKeys.created_at : ParameterKeys.desc]
        let bodyParams = [ParameterKeys.sorter : sorter]
        
        if !isSilent {Loader.show()}
        NotificationService.shared.fetchNotifications(body: bodyParams, params: params) { response in
            if !isSilent {Loader.dismiss()}
            switch response {
            case .success(let notifications):
                if (self.notifications == nil) || (self.pageNo == 1){
                    self.notifications = notifications
                }else{
                    self.notifications?.listing?.notifications?.append(contentsOf: notifications.listing?.notifications ?? [])
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
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            if (notifications?.listing?.notifications?.count ?? 0) == 0 { return 1 }
            else {  return notifications?.listing?.notifications?.count ?? 0 }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (notifications?.listing?.notifications?.count ?? 0) == 0 {
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (notifications?.listing?.notifications?.count ?? 0) == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenNotificationDescription)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.className, for: indexPath) as! NotificationTableViewCell
            let item = notifications?.listing?.notifications?[indexPath.row]
            cell.configure(item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((notifications?.listing?.notifications?.count ?? 0) - 3){
            if (pageNo + 1) <= notifications?.listing?.paginationInfo?.totalPages ?? 0{
                pageNo += 1
                fetchNotification()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (notifications?.listing?.notifications?.count ?? 0) == 0 {
            
        } else {
            let item = notifications?.listing?.notifications?[indexPath.row]
            self.updateNotificationStatus(at: indexPath)
            
            let type = NotificationType(rawValue: item?.data?.type ?? "")
            switch type {
            case .Order:
                let orderStatus = OrderStatus(rawValue: item?.data?.status ?? "")
                let orderType = self.getOrderTypeBy(status: orderStatus ?? .PENDING)
                self.goToOrderDetail(of: item?.data?.orderId ?? "", filters: [orderStatus ?? .PENDING], type: orderType)
            case .Consumer:
                self.goToProfileSettings()
            case .FebysPlus:
                self.goToFebysPlus()
            case .QuestionAnswers:
                self.goToProductDetail(item?.data?.productId ?? "", threadId: item?.data?.threadId ?? "")
            default:
                break
            }
        }
    }
}
