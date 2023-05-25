//
//  AccountViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 07/09/2021.
//

import UIKit

class AccountViewController: UIViewController {
    
    //MARK: OUTLETS
    @IBOutlet weak var userName: FebysLabel!
    @IBOutlet weak var userSubscriberBadge: UIImageView!
    @IBOutlet weak var viewCartButton: FebysButton!
    @IBOutlet weak var cartCountLabel: FebysLabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: PROPERTIES
    var accountData: [AccountCells] = []
    var orderCells: [Setting]?
    var locationCells: [Setting]?
    var settingCells: [Setting]?
    var supportCells: [Setting]?
    
    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupButtonActions()
        fetchAccountData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: .cartUpdated, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = User.fetch() { fetchUserWallet() }
        configureUserName()
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
    }
    
    //MARK: IBActions
    func didHideSubscriptionBadge(_ isHidden: Bool) {
        self.userSubscriberBadge.isHidden = isHidden ? true : false
    }
    
    func setupButtonActions(_ view: UIView? = nil) {
        viewCartButton.didTap = {
            RedirectionManager.shared.showCart()
        }
        
        if let v = view as? AccountLoginHeaderView {
            v.signInButton.didTap = { [weak self] in
                self?.goToLogin()
            }
            
            v.signUpButton.didTap = { [weak self] in
                self?.goToSignup()
            }
        }
    }
    
    func prepareData() {
        accountData.removeAll()
        
        if let orderCells = orderCells {
            if !orderCells.isEmpty {
                accountData.append(.orders(orderCells))
            }
        }
        
        if let locationCells = locationCells {
            if !locationCells.isEmpty {
                accountData.append(.location(locationCells))
            }
        }
        
        if let settingCells = settingCells {
            if !settingCells.isEmpty {
                accountData.append(.settings(settingCells))
            }
        }
        
        if let supportCells = supportCells {
            if !supportCells.isEmpty {
                accountData.append(.support(supportCells))
            }
        }
        
        tableView.reloadData()
    }
    
    func configureUserName() {
        if let user = UserInfo.fetch() {
            self.userName.text = user.consumerInfo?.first_name?.capitalized
            if let subscription = user.subscription {
                self.didHideSubscriptionBadge(false)
                if let url = subscription.packageInfo?.icon {
                    self.userSubscriberBadge.setImage(url: url)
                }
            } else {
                self.didHideSubscriptionBadge(true)
            }
        } else {
            self.userName.text = "Me"
            self.didHideSubscriptionBadge(true)
        }
    }
    
    // MARK: Helpers
    @objc func updateCartCount(){
        cartCountLabel.text = "\(CartEntity.getAllCartItems())"
        cartCountLabel.animate(duration: 0.3)
        
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        if let _ = UserInfo.fetch()?.consumerInfo {
            self.profileUpdate(state: mySwitch.isOn) { state in
                if let userId = UserInfo.fetch()?.consumerInfo?.id {
                    if state {
                        FirebaseManager.shared.subscribeToTopic(userId)
                    } else {
                        FirebaseManager.shared.unSubscribeToTopic(userId)
                    }
                }
            }
        }
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.tableHeaderView?.backgroundColor = .white
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        
        tableView.register(SearchListCell.className)
        tableView.registerHeaderFooter(WalletBallanceHeaderView.className)
        tableView.registerHeaderFooter(AccountLoginHeaderView.className)
        tableView.registerHeaderFooter(AccountSignoutFooterView.className)
        tableView.registerHeaderFooter(CustomTableViewHeader.className)
    }
    
    // MARK: NAVIGATION
    func goTo<T: UIViewController>(controller: T, from: storyboards) {
        let vc = UIStoryboard.getVC(from: from, T.className) as! T
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToLogin() {
        let vc = UIStoryboard.getVC(from: .Auth, SignInViewController.className) as! SignInViewController
        vc.redirectToHome = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSignup() {
        let vc = UIStoryboard.getVC(from: .Auth, SignUpViewController.className) as! SignUpViewController
        vc.redirectToHome = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToOrderListing(with filters: [OrderStatus], type orderType: OrderType) {
        let vc = UIStoryboard.getVC(from: .Orders, OrderListingViewController.className) as! OrderListingViewController
        vc.filters = filters
        vc.orderType = orderType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToWebView(title: String, url: String){
        let vc = UIStoryboard.getVC(from: .Account, WebViewViewController.className) as! WebViewViewController
        vc.urlString = url
        vc.titleName = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: API CALLS
    func fetchUserWallet() {
        WalletService.shared.fetchUserWallet { response in
            switch response {
            case .success(let walletResponse):
                var userInfo = UserInfo.fetch()
                userInfo?.wallet = walletResponse.wallet
                _ = userInfo?.save()
                self.convertWalletCurrency()
                break
            case .failure(let error):
                print("WalletError: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func profileUpdate(state: Bool, completion: ((Bool) -> ())? = nil){
        let bodyParams = [ParameterKeys.notificationsStatus : state ? 1 : 0]
        UserService.shared.profileUpdate(body: bodyParams) { response in
            switch response{
            case .success(let userResponse):
                var userInfo = UserInfo.fetch()
                userInfo?.consumerInfo = userResponse.user
                let isSaved = userInfo?.save()
                if isSaved ?? false {
                    if let status = userInfo?.consumerInfo?.notificationsStatus {
                        if status == 0 {
                            completion?(false)
                        } else if status == 1 {
                            completion?(true)
                        }
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    func convertWalletCurrency() {
        PurchaseService.shared.convertWalletIntoCurrent(currency: "GHS") { (currency, balance) in
            var userInfo = UserInfo.fetch()
            userInfo?.wallet?.convertedCurrency = currency
            userInfo?.wallet?.convertedBalance = Double(balance)
            _ = userInfo?.save()
            self.tableView.reloadData()
        }
    }
    
    func userSignOut() {
        if let userId = UserInfo.fetch()?.consumerInfo?.id {
            FirebaseManager.shared.unSubscribeToTopic(userId)
        }
        DispatchQueue.main.async {
            CartEntity.clearAllFromCoreData()
            User.remove()
            UserInfo.remove()
            ShippingDetails.remove()
            WishlistManager.shared.clearWishList()
            RedirectionManager.shared.gotoHome()
            ZendeskManager.shared.resetVisitorIdentity()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func fetchAccountData() {
        let data = AccountService.shared.getAccountData()
        _ = data.compactMap({ account in
            switch account.type {
            case .orders(let settings):
                orderCells = settings
            case .location(let settings):
                locationCells = settings
            case .settings(let settings):
                settingCells = settings
            case .support(let settings):
                supportCells = settings
            }
        })
        prepareData()
    }
}

//MARK: UITableView
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accountData.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 {
            return 0
        } else {
            switch accountData[section - 1] {
            case .orders(let settings):
                return settings.count
            case .location(let settings):
                return settings.count
            case .settings(let settings):
                return settings.count
            case .support(let settings):
                return settings.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if User.fetch() == nil {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountLoginHeaderView.className) as! AccountLoginHeaderView
                self.setupButtonActions(header)
                return header
            } else {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: WalletBallanceHeaderView.className) as! WalletBallanceHeaderView
                
                header.configure()
                header.cellClickButton.didTap = { [weak self] in
                    self?.goTo(controller: WalletViewController(), from: .Wallet)
                }
                return header
            }
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeader.className) as! CustomTableViewHeader
            header.topConstraint.constant = 5
            header.bottomContraint.constant = 5
            
            switch accountData[section - 1] {
            case .orders(_):
                header.headerLabel.text = Constants.ordersSection
            case .location(_):
                header.headerLabel.text = Constants.myLocationSection
            case .settings(_):
                header.headerLabel.text = Constants.settingsSection
            case .support(_):
                header.headerLabel.text = Constants.supportSection
            }
            
            header.headerLabel.font = UIFont.helvetica(type: .medium, size: 16)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let _ = User.fetch() {
            if section == (tableView.numberOfSections - 1) {
                let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: AccountSignoutFooterView.className) as! AccountSignoutFooterView
                footer.logoutButton.didTap = { [weak self] in
                    self?.userSignOut()
                }
                return footer
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch accountData[indexPath.section - 1] {
        case .orders(let settings):
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
            cell.configure(settings: settings[indexPath.row])
            return cell
        case .location(let settings):
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
            cell.configure(settings: settings[indexPath.row])
            cell.didHideArrow(true)
            return cell
        case .settings(let settings):
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
            
            cell.toggleSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
            
            if let status = UserInfo.fetch()?.consumerInfo?.notificationsStatus {
                if status == 0 {
                    cell.toggleSwitch.isOn = false
                } else if status == 1 {
                    cell.toggleSwitch.isOn = true
                }
            }
            
            cell.configure(settings: settings[indexPath.row])
            return cell
        case .support(let settings):
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.className, for: indexPath) as! SearchListCell
            cell.configure(settings: settings[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch accountData[indexPath.section - 1] {
        case .orders(let settings):
            let row = settings[indexPath.row].title
            if row == Constants.myOrders {
                self.goToOrderListing(with: [.PENDING, .ACCEPTED, .SHIPPED, .CANCELLED_BY_VENDOR, .CANCELED, .REJECTED], type: .Order)
            } else if row == Constants.orderReceived {
                self.goToOrderListing(with: [.DELIVERED], type: .Received)
            } else if row == Constants.myReview {
                self.goToOrderListing(with: [.DELIVERED], type: .Review)
            } else if row == Constants.cancelOrders {
                self.goToOrderListing(with: [.CANCELLED_BY_VENDOR, .CANCELED, .REJECTED], type: .Cancel)
            } else if row == Constants.returnOrders {
                self.goToOrderListing(with: [.RETURNED, .PENDING_RETURN], type: .Return)
            } else if row == Constants.wishlist {
                goTo(controller: WishListViewController(), from: .WishList)
            }
        case .location(let settings):
            let row = settings[indexPath.row].title
            if row == Constants.userCountry {
                //                goTo(controller: WishListViewController(), from: .WishList)
            }
        case .settings(let settings):
            let row = settings[indexPath.row].title
            if row == Constants.notifications {
                //                goTo(controller: WalletViewController(), from: .Wallet)
            } else if row == Constants.accountSettings {
                goTo(controller: ProfileSettingViewController(), from: .Account)
            } else if row == Constants.vouchers {
                goTo(controller: VoucherViewController(), from: .Account)
            } else if row == Constants.shippingAddress {
                goTo(controller: ShippingAddressViewController(), from: .ShippingAddress)
            }
        case .support(let settings):
            let row = settings[indexPath.row].title
            if row == Constants.aboutFebys{
                let urlString = URLHelper.shared.getBaseURLString(with: URI.StaticPagesRoutes.aboutUs.rawValue)
                goToWebView(title: row ?? "", url: urlString )
            } else if row == Constants.helpCenter{
                let urlString = URLHelper.shared.getBaseURLString(with: URI.StaticPagesRoutes.helpCenter.rawValue)
                goToWebView(title: row ?? "", url: urlString )
            } else if row == Constants.privacyPolicy{
                let urlString = URLHelper.shared.getBaseURLString(with: URI.StaticPagesRoutes.privacyPolicy.rawValue)
                goToWebView(title: row ?? "", url: urlString )
            } else if row == Constants.termsAndConditions {
                let urlString = URLHelper.shared.getBaseURLString(with: URI.StaticPagesRoutes.termsAndCondition.rawValue)
                goToWebView(title: row ?? "", url: urlString )
            }
        }
    }
}

enum AccountCells {
    //    case login([Setting])
    case orders([Setting])
    case location([Setting])
    case settings([Setting])
    case support([Setting])
}

enum OrderStatus: String {
    case PENDING = "PENDING"
    case ACCEPTED = "ACCEPTED"
    case CANCELLED_BY_VENDOR = "CANCELLED_BY_VENDOR"
    case SHIPPED = "SHIPPED"
    case CANCELED = "CANCELED"
    case REJECTED = "REJECTED"
    case RETURNED = "RETURNED"
    case PENDING_RETURN = "PENDING_RETURN"
    case DELIVERED = "DELIVERED"
    
    func isAccepted() -> Bool {
        return [OrderStatus.PENDING,
                OrderStatus.REJECTED].contains(where: {$0 == self}) ? false : true
    }
    
    func isShipped() -> Bool {
        return [OrderStatus.PENDING,
                OrderStatus.CANCELED,
                OrderStatus.REJECTED,
                OrderStatus.CANCELLED_BY_VENDOR,
                OrderStatus.ACCEPTED].contains(where: {$0 == self}) ? false : true
    }
    
    func isReceived() -> Bool {
        return [OrderStatus.PENDING,
                OrderStatus.CANCELED,
                OrderStatus.REJECTED,
                OrderStatus.CANCELLED_BY_VENDOR,
                OrderStatus.ACCEPTED,
                OrderStatus.SHIPPED].contains(where: {$0 == self}) ? false : true
    }
}
