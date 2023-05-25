//
//  FebysPlusViewController.swift
//  febys
//
//  Created by Nouman Akram on 27/12/2021.
//

import UIKit

class FebysPlusViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variable
    var userSubscription: Subscription? = nil
    var subscribedPackageId = ""
    var selectedPackage: Package?
    var packageResponse : PackageResponse?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.getPackagesDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserSubsription()
    }
    
    //MARK: Helpers
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(PackagesTableViewCell.className)
        tableView.registerHeaderFooter(FebysPlusHeaderView.className)
    }
    
    func getUserSubsription() {
        if let subsription = UserInfo.fetch()?.subscription {
            self.userSubscription = subsription
        }
    }
    
    //MARK: Navigation
    func goToPaymentProcessing() {
        let vc = UIStoryboard.getVC(from: .Payments, PaymentsViewController.className) as! PaymentsViewController
        vc.delegate = self
        vc.orderAmount = self.selectedPackage?.price
        vc.orderPurpose = Constants.SUBSCRIPTION_PURCHASED
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Navigation
    func showPaymentMethodScreen() {
        let vc = UIStoryboard.getVC(from: .Payments, PaymentsViewController.className)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: API Calling
    func getPackagesDetails(){
        Loader.show()
        FebysPlusService.shared.getFebysPlusData { response in
            Loader.dismiss()
            switch response{
            case .success(let packageResponse):
                self.packageResponse = packageResponse
               self.tableView.reloadData()
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    //MARK: Purchase Subscription
    func subscribePackageBy(id: String?, transactions: [Transaction]?) {
        let bodyParams = [ParameterKeys.transaction_ids: getTransactionIds(of: transactions)] as [String:Any]
        
        Loader.show()
        FebysPlusService.shared.subscribePackageBy(id: id ?? "", body: bodyParams) { response in
            switch response {
            case .success(let packageResponse):
                let package = packageResponse.subscription?.packageInfo
                var userInfo = UserInfo.fetch()
                userInfo?.subscription = packageResponse.subscription
                _ = userInfo?.save()
                let message = "For choosing Febys Plus \(package?.title?.capitalized ?? "") Membership You have got \(package?.subscriptionDays ?? 0) days free delivery."
                
                self.showMessage(Constants.thankYou,message,messageImage:.thankYou) {
                    self.backButtonTapped(self)
                }
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription) {
                    self.backButtonTapped(self)
                }
            }
        }
    }
    
    func getTransactionIds(of transactions: [Transaction]?) -> [String] {
        var ids: [String] = []
        _ = transactions?.compactMap({ transaction in
            ids.append(transaction.id ?? "")
        })
        return ids
    }
}

//MARK: PaymentsDelegate
extension FebysPlusViewController: PaymentsDelegate {
    func proceedPurchase(with transactions: [Transaction]) {
        self.subscribePackageBy(id: selectedPackage?.id, transactions: transactions)
    }
}

//MARK: TableView Methods
extension FebysPlusViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageResponse?.packages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PackagesTableViewCell.className, for: indexPath) as! PackagesTableViewCell
        
        var item = packageResponse?.packages?[indexPath.row]
        let isSelected = item?.id == selectedPackage?.id
        let isSubscribed = item?.id == self.userSubscription?.packageInfo?.id
        item?.isSubscribed = isSubscribed
        
        cell.configure(item, isSelected: isSelected, isSubscribed: (self.userSubscription?.packageInfo != nil) ? true : false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FebysPlusHeaderView.className) as! FebysPlusHeaderView
        return header
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPackage = self.packageResponse?.packages?[indexPath.row]
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if User.fetch() != nil {
                self.goToPaymentProcessing()
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
    }
}




