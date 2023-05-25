//
//  ShippingAddressViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 17/09/2021.
//

import UIKit

class ShippingAddressViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var addNewAddressButton: FebysButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveAndContinueButton: FebysButton!
    
    //MARK: Variables
    var addresses: AddressResponse?
    var selectedAddress = ShippingDetails.fetch()
    var isLoading = true
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupButtonActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchShippingAddress()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(ShippingAddressTableViewCell.className)
        tableView.register(EmptyViewsTableViewCell.className)
    }
    
    //MARK: IBActions
    func setupButtonActions() {
        addNewAddressButton.didTap = { [weak self] in
            self?.goToAddAddress()
        }
        
        saveAndContinueButton.didTap = { [weak self] in
            self?.setSelectedAddress()
            self?.backButtonTapped(self!)
        }
    }
    
    //MARK: Helpers
    func setSelectedAddress() {
        let saved = selectedAddress?.save()
        if let saved = saved, saved {
            NotificationCenter.default.post(name: .addressUpdated, object: selectedAddress)
        }
    }
    
    //MARK: Navigation
    func goToAddAddress(_ details: ShippingDetails? = nil) {
        let vc = UIStoryboard.getVC(from: .ShippingAddress, AddAddressViewController.className) as! AddAddressViewController
        
        if details != nil { vc.shippingDetails = details }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: API Calling
    func fetchShippingAddress(){
        Loader.show()
        AddressService.shared.fetchShippingAddress { response in
            Loader.dismiss()
            switch response{
            case .success(let addresses):
                self.addresses = addresses
                self.addresses?.shippingDetails = addresses.shippingDetails?.sorted(by: { ($0.shippingDetail?.isDefault == true) && ($1.shippingDetail?.isDefault == false)
                })
                
                if let selectedAddress = self.selectedAddress {
                    self.selectedAddress = addresses.shippingDetails?
                        .first(where: { $0.id == selectedAddress.id})
                    _ = self.selectedAddress?.save()

                } else {
                    self.selectedAddress = addresses.shippingDetails?.first(where: {$0.shippingDetail?.isDefault == true}) ?? addresses.shippingDetails?.first
                    _ = self.selectedAddress?.save()

                }
                
                self.isLoading = false
                self.tableView.reloadData()
                self.saveAndContinueButton.isHidden = !((addresses.shippingDetails?.count ?? 0) > 0)
                
            case .failure(let error):
                self.isLoading = false
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
    
    func deleteShippingAddressBy(id: String){
        addresses?.shippingDetails?.removeAll(where: {$0.id == id})
        
        if let address = ShippingDetails.fetch(), address.id == id { ShippingDetails.remove()
        }
        
        if let selectedAddress = selectedAddress, selectedAddress.id == id {
            self.selectedAddress = nil
        }
        
        
        AddressService.shared.deleteShippingAddressBy(id: id) {response in}
        self.tableView.reloadData()
        self.saveAndContinueButton.isHidden = !((addresses?.shippingDetails?.count ?? 0) > 0)
    }
}

//MARK: UITableView
extension ShippingAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading {
            return 0
        } else {
            if addresses?.shippingDetails?.count ?? 0 == 0{return 1} else {return addresses?.shippingDetails?.count ?? 0}
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if addresses?.shippingDetails?.count ?? 0 == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if addresses?.shippingDetails?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenShippingAdressDescription)
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShippingAddressTableViewCell.className, for: indexPath) as? ShippingAddressTableViewCell else { return UITableViewCell() }
            
            let address = addresses?.shippingDetails?[indexPath.row]
            let isSelected = address?.id == selectedAddress?.id
            cell.configure(address, isSelected: isSelected)
            
            if let detail = addresses?.shippingDetails?[indexPath.row] {
                cell.editButton.didTap = { [weak self] in
                    self?.goToAddAddress(detail)
                }
                
                cell.deleteButton.didTap = { [weak self] in
                    self?.showMessage(Constants.areYouSure, Constants.youWantToDelete, messageImage: .delete, isQuestioning: true, onSuccess: {
                        self?.deleteShippingAddressBy(id: detail.id ?? "")
                    }, onDismiss: nil)
                }
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addresses?.shippingDetails?.count ?? 0 > 0 {
            var indexes = [indexPath]
            if let previous = addresses?.shippingDetails?
                .firstIndex(where: { $0.id == selectedAddress?.id }) {
                
                let previousIndex = IndexPath(row: previous,
                                              section: indexPath.section)
                indexes.append(previousIndex)
                
            }
            
            
            selectedAddress = addresses?.shippingDetails?[indexPath.row]
            tableView.reloadRows(at: indexes, with: .automatic)
        }
    }
}
