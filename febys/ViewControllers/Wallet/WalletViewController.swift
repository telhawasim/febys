//
//  WalletViewController.swift
//  febys
//
//  Created by Nouman Akram on 12/01/2022.
//

import UIKit

class WalletViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var totalRows = 0
    var pageNo = 1
    var pageSize = 15
    var transactionResponse : TransactionResponse?
    var isLoading = true

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewSetup()
        self.getTransactionHistory()
    }
    
    //MARK: Register Cell
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        tableView.registerHeaderFooter(WalletTableViewHeaderView.className)
        tableView.registerHeaderFooter(CustomTableViewHeader.className)
        tableView.register(TransactionHistoryTableViewCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    //MARK: Api Calling
    func getTransactionHistory(){
        let params = [ParameterKeys.chunkSize: pageSize,
                      ParameterKeys.pageNo: pageNo] as [String : Any]
        
        let dollarNE = [ParameterKeys.dollarNE : Constants.REFUND]
        let status = [ParameterKeys.status1 : dollarNE]
        let createdAt = [ParameterKeys.created_at : ParameterKeys.desc]
        
        let bodyParams = [ParameterKeys.filters : status,
                          ParameterKeys.sorter: createdAt ] as [String : Any]
        
        Loader.show()
        TransactionService.shared.transactionHistory(params: params, body: bodyParams) { response in
            Loader.dismiss()
            switch response{
            case .success(let transactionResponse):
                self.totalRows = transactionResponse.listing?.totalRows ?? 0
                if self.transactionResponse == nil{
                    self.transactionResponse = transactionResponse
                }else{
                    self.transactionResponse?.listing?.transactions?.append(contentsOf: transactionResponse.listing?.transactions ?? [])
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

//MARK: TableView Methods
extension WalletViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 0 }
        else {
            if isLoading {
                return 0
            } else {
                if (transactionResponse?.listing?.transactions?.count ?? 0) == 0 { return 1
                } else {
                    return transactionResponse?.listing?.transactions?.count ?? 0
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if transactionResponse?.listing?.transactions?.count ?? 0 == 0{
            return tableView.frame.height - 200
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header  = tableView.dequeueReusableHeaderFooterView(withIdentifier: WalletTableViewHeaderView.className) as! WalletTableViewHeaderView
            header.configure()
            
            header.withdrawButton.didTap = { [weak self] in
                self?.showMessage("Coming Soon", "Withdraw feature is coming soon", messageImage: .upcomming, onDismiss: nil)
            }
            
            header.topUpButton.didTap = { [weak self] in
                self?.showMessage("Coming Soon", "Top-Up feature is coming soon", messageImage: .upcomming, onDismiss: nil)
            }
            return header
        }else{
            let header  = tableView.dequeueReusableHeaderFooterView(withIdentifier: CustomTableViewHeader.className) as! CustomTableViewHeader
            header.headerLabel.text = "Transactions History"
            header.bottomContraint.constant = 10
            return header
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transactionResponse?.listing?.transactions?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenHistoryDescription)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionHistoryTableViewCell.className, for: indexPath) as! TransactionHistoryTableViewCell
            let item = transactionResponse?.listing?.transactions?[indexPath.row]
            cell.configure(item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((transactionResponse?.listing?.transactions?.count ?? 0) - 3){
            if (pageNo + 1) <= transactionResponse?.listing?.paginationInfo?.totalPages ?? 0{
                pageNo += 1
                getTransactionHistory()
            }
        }
    }
}

