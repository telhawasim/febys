//
//  VoucherViewController.swift
//  febys
//
//  Created by Abdul Kareem on 11/10/2021.
//

import UIKit

class VoucherViewController: BaseViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addVoucherButton: FebysButton!
    
    //MARK: Properties
    var vouchers: [Vouchers]?
    var isLoading = true

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewCotroller()
        setupButtons()
        fetchVouchers()
    }
    
    func setupButtons() {
        addVoucherButton.didTap = { [weak self] in
            self?.presentAddVoucherBottomSheet()
        }
    }
    
    //MARK: Helpers
    func configureViewCotroller(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top:0, left:0, bottom:120, right:0)
        tableView.register(VoucherTableViewCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    //MARK: Navigation
    func presentAddVoucherBottomSheet() {
        let vc = UIStoryboard.getVC(from: .Account, AddVoucherViewController.className) as! AddVoucherViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        RedirectionManager.shared.presentOnRoot(vc, animated: true, completion: nil)
    }
    
    //MARK: API Calling
    func fetchVouchers() {
        let createdAt = [ParameterKeys.created_at : ParameterKeys.desc]
        let bodyParams = [ParameterKeys.sorter: createdAt ] as [String : Any]
        
        Loader.show()
        VoucherService.shared.fetchVoucherListing(body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let vouchers):
                self.vouchers = vouchers.vouchers
                self.isLoading = false
                self.tableView.reloadData()
            case .failure(let error):
                self.isLoading = false
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}

//MARK: AddVoucherDelegate
extension VoucherViewController: AddVoucherDelegate {
    func voucherAddedSuccessfully() {
        self.fetchVouchers()
    }
}

//MARK: UITableView
extension VoucherViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 0
        } else {
            if vouchers?.count ?? 0 == 0{
                return 1
            } else {
                return vouchers?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if vouchers?.count ?? 0 == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vouchers?.count ?? 0  == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenVouchersDescription)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: VoucherTableViewCell.className, for: indexPath) as! VoucherTableViewCell
            cell.configure(self.vouchers?[indexPath.row])
            return cell
        }
    }
}
